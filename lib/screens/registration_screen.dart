import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../services/auth_service.dart';
import '../constants/strings.dart';
import '../constants/styles.dart';
import '../utils/validators.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedSex = 'Masculin';
  final _authService = AuthService();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final success = await _authService.register(
          name: _nameController.text,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          age: int.parse(_ageController.text),
          sex: _selectedSex,
        );

        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.registrationSuccessful)),
          );
          Navigator.of(context).pop(); // Return to login screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Strings.registrationFailed)),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(Strings.registrationError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.registration),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: Strings.name,
                prefixIcon: Icons.person,
                validator: Validators.validateName,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _usernameController,
                labelText: Strings.username,
                prefixIcon: Icons.account_circle,
                validator: Validators.validateUsername,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: Strings.email,
                prefixIcon: Icons.email,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                labelText: Strings.password,
                prefixIcon: Icons.lock,
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _ageController,
                labelText: Strings.age,
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: Validators.validateAge,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSex,
                decoration: Styles.inputDecoration.copyWith(
                  labelText: Strings.sex,
                  prefixIcon: const Icon(Icons.wc),
                ),
                items: ['Masculin', 'Feminin'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSex = newValue!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: Styles.primaryButtonStyle,
                onPressed: _isLoading ? null : _handleRegistration,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(Strings.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
