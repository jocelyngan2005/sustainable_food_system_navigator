from flask import Flask, request, jsonify
from main import recommend_foods, generate_meal_plan, suggest_recipes, df
from flask_cors import CORS
import pandas as pd

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter frontend

@app.route('/recommend-foods', methods=['POST'])
def api_recommend_foods():
    try:
        data = request.json
        filtered = recommend_foods(
            df,
            dietary_preference=data.get('dietary_preference'),
            min_sustainability_score=data.get('min_sustainability_score', 0),
        )
        # Convert to list of dicts
        result = filtered.to_dict('records')
        return jsonify({'success': True, 'data': result})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 400

@app.route('/generate-meal-plan', methods=['POST'])
def api_generate_meal_plan():
    try:
        data = request.json
        meal_plan = generate_meal_plan(
            df,
            dietary_preference=data['dietary_preference'],
            allergies=data['allergies'],
            duration=data['duration'],
            max_calories=data.get('max_calories'),
            min_sustainability_score=data.get('min_sustainability_score', 0),
        )
        return jsonify({'success': True, 'data': meal_plan})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 400

@app.route('/suggest-recipe', methods=['POST'])
def api_suggest_recipe():
    try:
        data = request.json
        recipe = suggest_recipes(
            data['ingredient'],
            data['meal_type'],
        )
        return jsonify({'success': True, 'data': recipe})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)}), 400
    
@app.route('/')
def home():
    return "Backend is running! Try /recommend-foods", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)