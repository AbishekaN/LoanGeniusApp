from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import numpy as np

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load the trained model
try:
    with open(r'C:\Users\nirma\Downloads\modelNew.pkl', 'rb') as file:
        model = pickle.load(file)
    print("Model loaded successfully!")
except Exception as e:
    print(f"Error loading the model: {e}")

# Define the route for the API
@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Ensure we received JSON data
        if not request.is_json:
            return jsonify({'error': 'Invalid input format. JSON expected.'}), 400

        data = request.json

        # Debug: Print the received data for validation
        print('Received Data:', data)

        # Extract features from the request data
        features = [
            data.get('ApplicantIncome', 0),
            data.get('CoapplicantIncome', 0),
            data.get('LoanAmount', 0),
            data.get('Loan_Amount_Term', 0),
            data.get('Credit_History', 0),
            data.get('Gender', 0),
            data.get('Married', 0),
            data.get('Dependents_0', 0),
            data.get('Dependents_1', 0),
            data.get('Dependents_2', 0),
            data.get('Dependents_3+', 0),
            data.get('Education', 0),
            data.get('Self_Employed', 0),
            data.get('Property_Area_Rural', 0),
            data.get('Property_Area_Semiurban', 0),
            data.get('Property_Area_Urban', 0)
        ]

        # Convert features to NumPy array and predict
        features = np.array([features])
        print(f'Features: {features}')

        # Prediction using the loaded model
        prediction = model.predict(features)
        print(f'Prediction: {prediction}')

        # If model supports predict_proba, calculate the probability
        if hasattr(model, 'predict_proba'):
            probability = model.predict_proba(features)[0][1]  # Assuming class 1 is "Approved"
            print(f'Probability: {probability}')
        else:
            probability = None

        # Return the prediction as a JSON response
        return jsonify({
            'loan_status': 'Approved' if prediction[0] == 1 else 'Not Approved',
            'probability': probability
        })

    except KeyError as e:
        print(f"Missing key in the input data: {e}")
        return jsonify({'error': f'Missing key: {str(e)}'}), 400
    except Exception as e:
        print(f"Error occurred during prediction: {e}")
        return jsonify({'error': f"Error during prediction: {str(e)}"}), 500


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0")
