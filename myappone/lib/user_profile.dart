import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io; // For mobile platforms
import 'dart:typed_data'; // For handling image data in Web
import 'dart:html' as html; // For Flutter Web
import 'package:flutter/foundation.dart'; // To check if we are running on the web

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  io.File? _profileImage; // For mobile image file
  String? _profileImageUrl; // To store profile image URL from Firestore or Base64 for web
  Uint8List? _webImage; // For Web platforms to store image bytes

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Load user profile when the screen is loaded
  }

  // Load the user's profile data from Firestore
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('officers')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc.get('name') ?? "";
            _emailController.text = userDoc.get('email') ?? "";
            _phoneController.text = userDoc.get('phone') ?? "";
            _profileImageUrl = userDoc.get('profileImageUrl') ?? ""; // Get profile image URL
          });
        } else {
          print("User profile does not exist in Firestore.");
        }
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Select an image from the gallery (supports both Web and Mobile)
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // For Flutter Web, use the html package to pick an image
      final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final reader = html.FileReader();

          reader.onLoadEnd.listen((e) {
            setState(() {
              _webImage = reader.result as Uint8List; // Store image bytes for web
            });
          });
          reader.readAsArrayBuffer(files[0]);
        }
      });
    } else {
      // For Mobile Platforms (Android/iOS)
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _profileImage = io.File(pickedImage.path); // Update state with the new image
        });
      }
    }
  }

  // Upload the selected image to Firebase Storage and return the download URL
  Future<String?> _uploadProfileImage() async {
    if (_profileImage == null && _webImage == null && _profileImageUrl == null) {
      print("No image selected for upload.");
      return null; // If no image is selected, return null
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final ref = _storage.ref().child('user_profile_images').child(user.uid + '.jpg'); // Set file path in Firebase Storage

        if (kIsWeb && _webImage != null) {
          // For Flutter Web, upload image bytes
          UploadTask uploadTask = ref.putData(_webImage!, SettableMetadata(contentType: 'image/jpeg'));
          TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          print("Uploaded image URL (Web): $downloadUrl");
          return downloadUrl;
        } else if (_profileImage != null) {
          // For Mobile, upload the file
          UploadTask uploadTask = ref.putFile(_profileImage!); // Upload the image file
          TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
          String downloadUrl = await snapshot.ref.getDownloadURL();
          print("Uploaded image URL (Mobile): $downloadUrl");
          return downloadUrl;
        }
      }
    } catch (e) {
      print("Error uploading profile image: $e");
    }
    return null;
  }

  // Save the updated profile details back to Firestore
  Future<void> _saveUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // Upload profile image if one is selected
        String? imageUrl = await _uploadProfileImage();
        if (imageUrl != null) {
          _profileImageUrl = imageUrl; // Update the profile image URL
        } else {
          print("No image URL returned. Using the old profile image URL.");
        }

        // Update Firestore with the new profile details
        await FirebaseFirestore.instance.collection('officers').doc(user.uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'profileImageUrl': _profileImageUrl, // Save the profile image URL
        });

        _showSnackBar('Profile updated successfully!', Colors.green);
      } else {
        print("User not logged in. Cannot save profile.");
      }
    } catch (e) {
      print("Error saving profile: $e");
      _showSnackBar('Failed to update profile. Please try again.', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to show a SnackBar with a message
  void _showSnackBar(String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            backgroundColor == Colors.green ? Icons.check_circle_outline : Icons.error_outline,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _getProfileImage(), // Function to get profile image based on platform
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.blue),
                  onPressed: _pickImage, // Pick an image from the gallery
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveUserProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get profile image based on the platform (Web or Mobile)
  ImageProvider _getProfileImage() {
    if (kIsWeb && _webImage != null) {
      // For web, use the uploaded image bytes
      return MemoryImage(_webImage!);
    } else if (_profileImage != null) {
      // For mobile, use FileImage
      return io.FileImage(_profileImage!);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      // For web or mobile, use NetworkImage if the profile image URL exists
      return NetworkImage(_profileImageUrl!);
    } else {
      // Default placeholder image
      return AssetImage('assets/user_icon.png');
    }
  }
}
