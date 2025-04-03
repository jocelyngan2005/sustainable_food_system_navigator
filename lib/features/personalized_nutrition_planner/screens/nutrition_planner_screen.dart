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
  String? dietaryPreference;
  final List<String> allergies = [];
  String? duration;
  int maxCalories = 2000;
  double minSustainabilityScore = 5.0;

  final TextEditingController _allergyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final double _borderRadius = 12.0;

  int _currentStep = 0; 

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }

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

  void _nextStep({int? step}) {
    setState(() {
      if (step != null) {
        _currentStep = step;
      } else {
        _currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    final sliderThemeData = SliderTheme.of(context).copyWith(
      activeTrackColor: const Color(0xFF5f8f58),
      inactiveTrackColor: const Color.fromARGB(255, 203, 204, 203),
      thumbColor: const Color(0xFF5f8f58),
      overlayColor: const Color(0xFF5f8f58),
      valueIndicatorColor: const Color(0xFF5f8f58),
      activeTickMarkColor: const Color(0xFF5f8f58),
      inactiveTickMarkColor: const Color.fromARGB(255, 152, 174, 148),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFfcf3dd),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Personalized Meal Planning',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Dietary Preference
                PreferenceSelector(
                  title: "Dietary Preference",
                  options: const ["Vegan", "Vegetarian", "Gluten-Free", "Pescatarian", "None"],
                  selectedValue: dietaryPreference,
                  onChanged: (value) {
                    setState(() {
                      dietaryPreference = value;
                    });
                    if (value != null) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _nextStep();
                      });
                    }
                  },
                  borderRadius: _borderRadius,
                ),
                const SizedBox(height: 20),

                // Allergies
                if (_currentStep >= 1) ...[
                  const Text(
                    "Allergies",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _allergyController,
                          decoration: InputDecoration(
                            hintText: "Enter an allergy",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(_borderRadius),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF5f8f58),
                          borderRadius: BorderRadius.circular(_borderRadius),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            _addAllergy();
                            if (allergies.isNotEmpty) {
                              Future.delayed(const Duration(milliseconds: 300), () {
                                _nextStep();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (allergies.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: allergies.map((allergy) {
                        return Chip(
                          label: Text(allergy),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => _removeAllergy(allergy),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],

                // Duration
                if (_currentStep >= 2) ...[
                  PreferenceSelector(
                    title: "Duration",
                    options: const ["daily", "weekly"],
                    selectedValue: duration,
                    onChanged: (value) {
                      setState(() {
                        duration = value;
                      });
                      if (value != null) {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          _nextStep(step: 3);
                        });
                      }
                    },
                    borderRadius: _borderRadius,
                  ),
                  const SizedBox(height: 20),
                ],

                // Max Calories, Sustainability Score, and Generate Button
                if (_currentStep >= 3) ...[
                  const Text(
                    "Max Daily Calories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SliderTheme(
                    data: sliderThemeData,
                    child: Slider(
                      value: maxCalories.toDouble(),
                      min: 500,
                      max: 5000,
                      divisions: 25,
                      label: '$maxCalories kcal',
                      onChanged: (value) {
                        setState(() {
                          maxCalories = value.round();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Min Sustainability Score (1-10)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SliderTheme(
                    data: sliderThemeData,
                    child: Slider(
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
                  ),
                  const SizedBox(height: 50),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5f8f58),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealPlanPage(
                            dietaryPreference: dietaryPreference ?? "None",
                            allergies: allergies,
                            duration: duration ?? "daily",
                            maxCalories: maxCalories,
                            minSustainabilityScore: minSustainabilityScore,
                            apiService: apiService,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Generate Meal Plan",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
