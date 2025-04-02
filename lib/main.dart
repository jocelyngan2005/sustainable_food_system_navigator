import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainable_food_system_navigator/login_screen.dart';
import 'package:sustainable_food_system_navigator/home_screen.dart';
import 'package:sustainable_food_system_navigator/features/crop_advisory_system/screens/crop_advisory_screen.dart';
import 'package:sustainable_food_system_navigator/features/food_supply_chain/screens/supply_chain_screen.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/screens/nutrition_planner_screen.dart';
import 'package:sustainable_food_system_navigator/features/personalized_nutrition_planner/services/nutrition_planner_api_service.dart';
import 'package:sustainable_food_system_navigator/features/predictive_food_waste_reduction/screens/food_waste_screen.dart';
import 'package:sustainable_food_system_navigator/features/climate_smart_farming/screens/smart_farming_screen.dart';


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
          primaryColor: const Color(0xFF5f8f58),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5f8f58)),
          scaffoldBackgroundColor: const Color(0xFFfcf3dd),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontWeight: FontWeight.w700),
            displayMedium: TextStyle(fontWeight: FontWeight.w600),
            displaySmall: TextStyle(fontWeight: FontWeight.w500),
            headlineMedium: TextStyle(fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
            bodyLarge: TextStyle(fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontWeight: FontWeight.normal),
            titleMedium: TextStyle(fontWeight: FontWeight.w500),
            titleSmall: TextStyle(fontWeight: FontWeight.w500),
            labelLarge: TextStyle(fontWeight: FontWeight.w600),
            bodySmall: TextStyle(fontWeight: FontWeight.normal),
            labelSmall: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/crop_advisory_system': (context) => const CropAdvisoryScreen(),
          '/food_supply_chain': (context) => const SupplyChainScreen(),
          '/personalized_nutrition_planner': (context) => const PersonalizedNutritionPlannerScreen(),
          '/predictive_food_waste_reduction': (context) => const FoodWasteReductionScreen(),
          '/climate_smart_farming': (context) => const ClimateSmartFarmingScreen(),
        },
        debugShowCheckedModeBanner: false,
      )
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfcf3dd),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/sustainable.png',
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.eco, size: 40, color: Color(0xFFB6D28A)),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Sustainable Food System Navigator',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF343434),
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 45),
            // Subtitle
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343434),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 40),
                child: Text(
                  'the Future of Food!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF343434),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/gif/battery.gif',
              height: 300,
              width: 300,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.eco, size: 100, color: Colors.green),
            ),
            const SizedBox(height: 40),
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Transforming the way we grow, distribute,',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF343434),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'and consume food with smart technology.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF343434),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 80),
              decoration: BoxDecoration(
                color: const Color(0xFF5f8f58),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 40),
            // Get Started Button
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Let\'s Get Started!',
                    style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFF343434),
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Image.asset(
                      'assets/images/arrow.png',
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
                    ),
                  ),  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

