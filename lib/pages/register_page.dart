import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart'; // ✅ IMPORT HII

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _sirNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? _selectedStreet;

  final List<String> _streetsUnguja = [
    'Kikwajuni', 'Mwembeshauri', 'Magomeni', 'Mtoni',
    'Amani', 'Mpendae', 'Kijito Upele', 'Kilimahewa',
  ];

  // ✅ USING AUTH SERVICE
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    try {
      await AuthService.register(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        secondName: _secondNameController.text.trim(),
        sirName: _sirNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        dob: _dobController.text.trim(),
        street: _selectedStreet ?? '',
        houseNumber: _houseController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      _clearForm();
      Navigator.pushReplacementNamed(context, '/login');
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() { _isLoading = false; });
    }
  }

  void _clearForm() {
    _firstNameController.clear();
    _secondNameController.clear();
    _sirNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _dobController.clear();
    _houseController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _usernameController.clear();
    setState(() { _selectedStreet = null; });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0066CC),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _dobController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF0066CC),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateToLogin,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white, Colors.grey.shade50],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.blue.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0066CC),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person_add_alt_1, size: 40, color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                const Text('User Registration', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0066CC))),
                                const SizedBox(height: 8),
                                Text('Fill in your details below', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                                const SizedBox(height: 8),
                                Text('Server: 127.0.0.1:8000', style: TextStyle(fontSize: 12, color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Personal Info
                          _buildSectionHeader('Personal Information'),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(child: _buildTextField(_firstNameController, 'First Name', Icons.person_outline, (value) => value!.isEmpty ? 'Required' : null)),
                              const SizedBox(width: 12),
                              Expanded(child: _buildTextField(_secondNameController, 'Middle Name', Icons.person_outlined, (value) => value!.isEmpty ? 'Required' : null)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_sirNameController, 'Last Name', Icons.family_restroom, (value) => value!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),

                          // Contact Info
                          _buildSectionHeader('Contact Information'),
                          const SizedBox(height: 16),
                          _buildTextField(_emailController, 'Email', Icons.email_outlined, (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email';
                            return null;
                          }),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneController, 'Phone', Icons.phone_android, (value) {
                            if (value!.isEmpty) return 'Required';
                            if (!RegExp(r'^[0-9]{9,12}$').hasMatch(value)) return 'Invalid phone';
                            return null;
                          }),
                          const SizedBox(height: 16),

                          // Date of Birth
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Date of Birth', prefixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white,
                            ),
                            onTap: _selectDate,
                            validator: (value) => value!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),

                          // Address Info
                          _buildSectionHeader('Address Information'),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedStreet,
                            decoration: InputDecoration(
                              labelText: 'Select Street', prefixIcon: Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white,
                            ),
                            items: _streetsUnguja.map((street) => DropdownMenuItem(value: street, child: Text(street))).toList(),
                            onChanged: (value) => setState(() { _selectedStreet = value; }),
                            validator: (value) => value == null ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_houseController, 'House Number', Icons.home_work_outlined, (value) => value!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),

                          // Account Info
                          _buildSectionHeader('Account Details'),
                          const SizedBox(height: 16),
                          _buildTextField(_usernameController, 'Username', Icons.person_pin, (value) => value!.isEmpty ? 'Required' : null),
                          const SizedBox(height: 16),
                          _buildTextField(_passwordController, 'Password', Icons.lock_outline, (value) => value!.length < 6 ? 'Min 6 characters' : null, obscureText: true),
                          const SizedBox(height: 16),
                          _buildTextField(_confirmPasswordController, 'Confirm Password', Icons.lock_reset, (value) => value != _passwordController.text ? 'Passwords mismatch' : null, obscureText: true),
                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity, height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0066CC), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: _isLoading ? const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Complete Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)]),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Login Link
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('Already have an account? ', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                            GestureDetector(onTap: _navigateToLogin, child: const Text('Login here', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0066CC)))),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(children: [
      Container(height: 2, width: 30, decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF0066CC), Colors.blue.shade300]), borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 12), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0066CC))), const Spacer(),
      Container(height: 2, width: 30, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade300, const Color(0xFF0066CC)]), borderRadius: BorderRadius.circular(2))),
    ]);
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String? Function(String?)? validator, {bool obscureText = false}) {
    return TextFormField(
      controller: controller, obscureText: obscureText,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose(); _secondNameController.dispose(); _sirNameController.dispose(); _emailController.dispose(); _phoneController.dispose(); _dobController.dispose(); _houseController.dispose(); _passwordController.dispose(); _confirmPasswordController.dispose(); _usernameController.dispose();
    super.dispose();
  }
}