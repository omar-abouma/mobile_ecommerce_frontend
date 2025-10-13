// lib/pages/view_orders_page.dart
import 'package:flutter/material.dart';

class ViewOrdersPage extends StatelessWidget {
  const ViewOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Orders')),
      body: const Center(child: Text('This is the View Orders page')),
    );
  }
}
