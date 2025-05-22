import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';
import '../models/user.dart';
import 'home_screen.dart';   

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final roleController = TextEditingController();

  final specializationController = TextEditingController();
  final poiIdController = TextEditingController();

  String selectedRole = 'user';

  void register() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      final name = nameController.text;

      final role = selectedRole;
      final specialization = specializationController.text;
      final poiId = poiIdController.text;

      final response = await AuthService.register(
        email: email,
        password: password,
        name: name,
        role: role,
        specialization: specialization,
        poiId: poiId,
      );

      final user = User.fromJson(response); 
      //band aid fix make sure to fix this later
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
      return;
      //band aid fix make sure to fix this later

      
      // ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar(content: Text(response['message'] ?? 'Registration failed')),
      // );
    }
  }

  Widget _buildRoleSpecificFields() {
    switch (selectedRole) {
      case 'doctor':
        return Column(
          children: [
            CustomTextField(controller: specializationController, label: 'Specialization'),
            CustomTextField(controller: poiIdController, label: 'POI ID (Doctor)'),
          ],
        );
      case 'customer_service':
        return CustomTextField(controller: poiIdController, label: 'POI ID (Customer Service)');
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextField(controller: emailController, label: 'Email'),
              CustomTextField(controller: passwordController, label: 'Password', isPassword: true),
              CustomTextField(controller: nameController, label: 'Name'),
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (value) => setState(() => selectedRole = value!),
                items: ['user', 'doctor', 'customer_service']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 16),
              _buildRoleSpecificFields(),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
