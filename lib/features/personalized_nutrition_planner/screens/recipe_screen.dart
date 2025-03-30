import 'package:flutter/material.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/services/nutrition_planner_api_service.dart';

class RecipePage extends StatefulWidget {
  final String foodName;
  final String mealType;
  final ApiService apiService;

  const RecipePage({
    super.key,
    required this.foodName,
    required this.mealType,
    required this.apiService,
  });

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late Future<String> _recipeFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  void _loadRecipe() {
    setState(() {
      _isLoading = true;
    });
    
    _recipeFuture = widget.apiService
        .suggestRecipe(widget.foodName, widget.mealType)
        .whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadRecipe,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<String>(
              future: _recipeFuture,
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
                          onPressed: _loadRecipe,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No recipe available'));
                }

                final recipe = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food image placeholder with meal type
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getMealIcon(),
                                size: 80,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.mealType,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Recipe content
                      Text(
                        recipe,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  IconData _getMealIcon() {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.breakfast_dining;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }
}