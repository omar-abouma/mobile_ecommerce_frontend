// lib/pages/payment_report_page.dart
import 'package:flutter/material.dart';

class PaymentReportPage extends StatelessWidget {
  const PaymentReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Report')),
      body: const Center(child: Text('This is the Payment Report page')),
    );
  }
}
