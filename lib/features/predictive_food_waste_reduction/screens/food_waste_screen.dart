import 'package:flutter/material.dart';

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