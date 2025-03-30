import 'package:flutter/material.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/screens/meal_plan_screen.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/widgets/preference_selector.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/services/nutrition_planner_api_service.dart';

class PersonalizedNutritionPlannerScreen extends StatefulWidget {
  const PersonalizedNutritionPlannerScreen({super.key});

  @override
  State<PersonalizedNutritionPlannerScreen> createState() => _PersonalizedNutritionPlannerState();
}

class _PersonalizedNutritionPlannerState extends State<PersonalizedNutritionPlannerScreen> {
  String? dietaryPreference = "None";
  final List<String> allergies = [];
  String duration = "daily";
  int maxCalories = 2000;
  double minSustainabilityScore = 5.0;

  final TextEditingController _allergyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addAllergy() {
    if (_allergyController.text.isNotEmpty) {
      setState(() {
        allergies.add(_allergyController.text.trim());
        _allergyController.clear();
      });
    }
  }

  void _removeAllergy(String allergy) {
    setState(() {
      allergies.remove(allergy);
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Nutrition Planner'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Personalized Meal Planning',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Dietary Preference
              PreferenceSelector(
                title: "Dietary Preference",
                options: const ["Vegan", "Vegetarian", "Gluten-Free", "Pescatarian", "None"],
                selectedValue: dietaryPreference,
                onChanged: (value) {
                  setState(() {
                    dietaryPreference = value;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Allergies
              const Text(
                "Allergies",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _allergyController,
                      decoration: const InputDecoration(
                        hintText: "Enter an allergy",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (allergies.isEmpty && value!.isEmpty) {
                          return "Add at least one allergy or enter 'None'";
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addAllergy,
                  ),
                ],
              ),
              
              // Allergy chips
              Wrap(
                spacing: 8.0,
                children: allergies.map((allergy) {
                  return Chip(
                    label: Text(allergy),
                    onDeleted: () => _removeAllergy(allergy),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 20),
              
              // Duration
              PreferenceSelector(
                title: "Duration",
                options: const ["daily", "weekly"],
                selectedValue: duration,
                onChanged: (value) {
                  setState(() {
                    duration = value!;
                  });
                },
              ),
              
              const SizedBox(height: 20),
              
              // Calories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Max Daily Calories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: maxCalories.toDouble(),
                    min: 500,
                    max: 3000,
                    divisions: 25,
                    label: maxCalories.toString(),
                    onChanged: (value) {
                      setState(() {
                        maxCalories = value.round();
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Sustainability Score
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Min Sustainability Score (1-10)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: minSustainabilityScore,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: minSustainabilityScore.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() {
                        minSustainabilityScore = value;
                      });
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Generate Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealPlanPage(
                          dietaryPreference: dietaryPreference ?? "None",
                          allergies: allergies,
                          duration: duration,
                          maxCalories: maxCalories,
                          minSustainabilityScore: minSustainabilityScore,
                          apiService: apiService,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Generate Meal Plan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}