import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/items_page.dart';
import 'pages/view_orders_page.dart';
import 'pages/payment_report_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Utensil E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Anza na Login Page
      home: const LoginPage(),
      
      // Weka routes za zote pages
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
         '/items': (context) => const ItemsPage(),
        '/view_orders': (context) => const ViewOrdersPage(),
        '/payment_report': (context) => const PaymentReportPage(),
      },
    );
  }
}