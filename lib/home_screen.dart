import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5f8f58),
      body: Stack(
        children: [
          // Main Content
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sustainable                  ',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Food System',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Click on the ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFffffff),
                      ),
                    ),
                    Text(
                      'buttons ',
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFf2c763),
                      ),
                    ),
                    Text(
                      'below to explore!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFffffff),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          Positioned(
            top: 50,
            right: 30,
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 30),
              onPressed: () {
                // Add your menu functionality here
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),

          // Permanent Panel with Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 615,
              decoration: const BoxDecoration(
                color: Color(0xFFfcf3dd),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildNavigationButton(
                      context,
                      'Crop Advisory System',
                      '/crop_advisory_system',
                    ),
                    const SizedBox(height: 30),
                    _buildNavigationButton(
                      context,
                      'Food Supply Chain',
                      '/food_supply_chain',
                    ),
                    const SizedBox(height: 30),
                    _buildNavigationButton(
                      context,
                      'Personalized Nutrition Planner',
                      '/personalized_nutrition_planner',
                    ),
                    const SizedBox(height: 30),
                    _buildNavigationButton(
                      context,
                      'Predictive Food Waste Reduction',
                      '/predictive_food_waste_reduction',
                    ),
                    const SizedBox(height: 30),
                    _buildNavigationButton(
                      context,
                      'Climate-Smart Farming',
                      '/climate_smart_farming',
                    ),
                    const SizedBox(height: 45),
                    Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 80),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5f8f58),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
    BuildContext context,
    String title,
    String routeName,
  ) {
    return SizedBox(
      width: 350,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5f8f58),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () {
          Navigator.pushNamed(context, routeName);
        },
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFFfcf3dd),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}