import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Image.asset(
                  'assets/images/sustainable.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.error, size: 100, color: Colors.grey),
                ),
              ),
              _buildNavigationButton(
                context,
                'Crop Advisory System',
                '/crop_advisory_system',
              ),
              const SizedBox(height: 16),
              _buildNavigationButton(
                context,
                'Food Supply Chain',
                '/food_supply_chain',
              ),
              const SizedBox(height: 16),
              _buildNavigationButton(
                context,
                'Personalized Nutrition Planner',
                '/personalized_nutrition_planner',
              ),
              const SizedBox(height: 16),
              _buildNavigationButton(
                context,
                'Predictive Food Waste Reduction',
                '/predictive_food_waste_reduction',
              ),
              const SizedBox(height: 16),
              _buildNavigationButton(
                context,
                'Climate-Smart Farming',
                '/climate_smart_farming',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    String routeName,
  ) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB6D28A),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF343434),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}