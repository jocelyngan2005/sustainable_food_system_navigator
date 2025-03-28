import 'package:flutter/material.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/models/meal_plan.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/services/nutrition_planner_api_service.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/widgets/food_card.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/screens/recipe_screen.dart';

class MealPlanPage extends StatefulWidget {
  final String dietaryPreference;
  final List<String> allergies;
  final String duration;
  final int maxCalories;
  final double minSustainabilityScore;
  final ApiService apiService;

  const MealPlanPage({
    super.key,
    required this.dietaryPreference,
    required this.allergies,
    required this.duration,
    required this.maxCalories,
    required this.minSustainabilityScore,
    required this.apiService,
  });

  @override
  State<MealPlanPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {
  late Future<MealPlan> _mealPlanFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMealPlan();
  }

  void _loadMealPlan() {
    setState(() {
      _isLoading = true;
    });
    
    _mealPlanFuture = widget.apiService.generateMealPlan(
      dietaryPreference: widget.dietaryPreference,
      allergies: widget.allergies,
      duration: widget.duration,
      maxCalories: widget.maxCalories,
      minSustainabilityScore: widget.minSustainabilityScore,
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meal Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadMealPlan,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<MealPlan>(
              future: _mealPlanFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadMealPlan,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No meal plan available'));
                }

                final mealPlan = snapshot.data!;

                return RefreshIndicator(
                  onRefresh: () async {
                    _loadMealPlan();
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${mealPlan.duration == "daily" ? "Today's" : "This Week's"} Meal Plan',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...mealPlan.plan.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...entry.value.entries.map((meal) {
                                return FoodCard(
                                  mealType: meal.key,
                                  foodName: meal.value,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RecipePage(
                                          foodName: meal.value,
                                          mealType: meal.key,
                                          apiService: widget.apiService,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                              const SizedBox(height: 20),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}