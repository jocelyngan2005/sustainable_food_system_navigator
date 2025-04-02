import 'package:flutter/material.dart';

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