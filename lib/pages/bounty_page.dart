import 'package:flutter/material.dart';

class BountyPage extends StatelessWidget {
  const BountyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bounty'),
      ),
      body: const Center(
        child: Text(
          'Bounty Page Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
