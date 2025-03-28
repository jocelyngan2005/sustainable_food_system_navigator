import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/screens/nutrition_planner_screen.dart';

void main() {
  runApp(const MyApp());
}

class AppRoutes {
  static const String home = '/';
  static const String cropAdvisory = '/crop_advisory';
  static const String foodSupply = '/food_supply';
  static const String nutritionPlanner = '/nutrition_planner';
  static const String wasteReduction = '/waste_reduction';
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.cropAdvisory,
      builder: (context, state) => const CropAdvisorySystemScreen(),
    ),
    GoRoute(
      path: AppRoutes.foodSupply,
      builder: (context, state) => const FoodSupplyChainScreen(),
    ),
    GoRoute(
      path: AppRoutes.nutritionPlanner,
      builder: (context, state) => const PersonalizedNutritionPlannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.wasteReduction,
      builder: (context, state) => const FoodWasteReductionScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Sustainable Food System Navigator',
      theme: ThemeData(
        primarySwatch: Colors.green, // Changed to green for sustainability theme
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sustainable Food System Navigator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureButton(
              title: 'Crop Advisory System',
              onPressed: () => context.go(AppRoutes.cropAdvisory),
              color: Colors.green[700]!,
            ),
            _buildFeatureButton(
              title: 'Food Supply Chain Transparency',
              onPressed: () => context.go(AppRoutes.foodSupply),
              color: Colors.blue[700]!,
            ),
            _buildFeatureButton(
              title: 'Personalized Nutrition Planner',
              onPressed: () => context.go(AppRoutes.nutritionPlanner),
              color: Colors.orange[700]!,
            ),
            _buildFeatureButton(
              title: 'Predictive Food Waste Reduction',
              onPressed: () => context.go(AppRoutes.wasteReduction),
              color: Colors.purple[700]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton({
    required String title,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 300, // Fixed width for better appearance
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(double.infinity, 50), // Full width within SizedBox
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Feature Screens
class CropAdvisorySystemScreen extends StatelessWidget {
  const CropAdvisorySystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Advisory System')),
      body: const Center(child: Text('Crop Advisory System Content')),
    );
  }
}

class FoodSupplyChainScreen extends StatelessWidget {
  const FoodSupplyChainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Supply Chain Transparency')),
      body: const Center(child: Text('Food Supply Chain Transparency Content')),
    );
  }
}

// class PersonalizedNutritionPlannerScreen extends StatelessWidget {
//   const PersonalizedNutritionPlannerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Personalized Nutrition Planner')),
//       body: const Center(child: Text('Personalized Nutrition Planner Content')),
//     );
//   }
// }

class FoodWasteReductionScreen extends StatelessWidget {
  const FoodWasteReductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Predictive Food Waste Reduction System')),
      body: const Center(child: Text('Predictive Food Waste Reduction System Content')),
    );
  }
}