import 'package:flutter/material.dart';

class SupplyChainScreen extends StatelessWidget {
  const SupplyChainScreen({super.key});

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