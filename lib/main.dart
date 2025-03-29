import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/screens/nutrition_planner_screen.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/services/nutrition_planner_api_service.dart';

void main() {
  runApp(const SustainableFoodSystemApp());
}

class SustainableFoodSystemApp extends StatelessWidget {
  const SustainableFoodSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
      create: (context) => ApiService(),
      child: MaterialApp(
        title: 'Sustainable Food System Navigator',
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/crop_advisory_system': (context) => const CropAdvisoryScreen(),
          '/food_supply_chain': (context) => const FoodSupplyScreen(),
          '/personalized_nutrition_planner': (context) => const PersonalizedNutritionPlannerScreen(),
          '/predictive_food_waste_reduction': (context) => const FoodWasteReductionScreen(),
          '/climate_smart_farming': (context) => const ClimateSmartFarmingScreen(),
        },
        debugShowCheckedModeBanner: false,
      )
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
            _buildNavigationButton(
              context,
              'Crop Advisory System',
              '/crop_advisory_system',
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildNavigationButton(
              context,
              'Food Supply Chain',
              '/food_supply_chain',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildNavigationButton(
              context,
              'Nutrition Planner',
              '/personalized_nutrition_planner',
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildNavigationButton(
              context,
              'Food Waste Reduction',
              '/predictive_food_waste_reduction',
              Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildNavigationButton(
              context,
              'Climate-Smart Farming',
              '/climate_smart_farming',
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    String routeName,
    MaterialColor color,
  ) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Feature Screens
class CropAdvisoryScreen extends StatelessWidget {
  const CropAdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Advisory System'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Crop Advisory System Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FoodSupplyScreen extends StatelessWidget {
  const FoodSupplyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Supply Chain'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Food Supply Chain Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// class PersonalizedNutritionPlannerScreen extends StatelessWidget {
//   const PersonalizedNutritionPlannerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Nutrition Planner'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: const Center(
//         child: Text(
//           'Personalized Nutrition Planner Content',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

class FoodWasteReductionScreen extends StatelessWidget {
  const FoodWasteReductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Waste Reduction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Predictive Food Waste Reduction Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class ClimateSmartFarmingScreen extends StatelessWidget {
  const ClimateSmartFarmingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate-Smart Farming'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          'Climate-Smart Farming Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}