from flask import Flask, request, jsonify
import os
import io
from google.cloud import vision
import tensorflow as tf
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
import joblib
import logging
from flask_cors import CORS
from predictor import CropYieldPredictor

app = Flask(__name__)
CORS(app)

# Set your Google Cloud API key
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "path/to/your/key.json"

# Initialize Vision API Client
client = vision.ImageAnnotatorClient()

# Initialize CropYieldPredictor with the path to the saved model
predictor = CropYieldPredictor(model_path='crop_yield_model')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get input data from request
        data = request.json
        
        # Validate input data
        required_fields = [
            'Area', 'Item', 'Year', 
            'average_rain_fall_mm_per_year', 
            'pesticides_tonnes', 
            'avg_temp'
        ]
        
        # Check for missing fields
        for field in required_fields:
            if field not in data:
                return jsonify({
                    'error': f'Missing required field: {field}',
                    'status': 'error'
                }), 400
        
        # Validate input data
        try:
            input_data = {
                'Area': str(data['Area']),
                'Item': str(data['Item']),
                'Year': int(data['Year']),
                'average_rain_fall_mm_per_year': float(data['average_rain_fall_mm_per_year']),
                'pesticides_tonnes': float(data['pesticides_tonnes']),
                'avg_temp': float(data['avg_temp'])
            }
        except (ValueError, TypeError) as e:
            return jsonify({'error': f'Invalid input data: {e}', 'status': 'error'}), 400
        
        # Make prediction
        yield_prediction = predictor.predict_yield(input_data)
        
        # Return prediction
        return jsonify({
            'yield': yield_prediction,
            'status': 'success'
        })
    
    except ValueError as e:
        logging.error(f"ValueError: {e}")
        return jsonify({'error': str(e), 'status': 'error'}), 400
    except Exception as e:
        logging.error(f"Unexpected error: {e}")
        return jsonify({'error': 'Internal server error', 'status': 'error'}), 500
    
@app.route('/health', methods=['GET'])
def health_check():
    """
    Health check endpoint to verify API is running
    """
    return jsonify({
        'status': 'healthy',
        'model_loaded': predictor.model is not None
    })

@app.route('/detect', methods=['POST'])
def detect():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    try:
        file = request.files['file']
        content = file.read()

        image = vision.Image(content=content)
        response = client.label_detection(image=image)
        labels = response.label_annotations

        results = [{'description': label.description, 'score': label.score} for label in labels]
        return jsonify({'labels': results})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
