import 'package:flutter/material.dart';
import 'package:smart_health_management/core/theme.dart';
import 'package:smart_health_management/ui/widgets/loading_overlay.dart';
import 'package:smart_health_management/utils/form_validators.dart';

import 'auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        fullName: _nameController.text.trim(),

      );


      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = "Registration failed";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor:
            isDark ? AppTheme.darkBackgroundColor : AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Create Account'),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Join Us',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextColor
                              : AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your account to get started',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline,
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600]),
                    ),
                    validator: FormValidators.validateName,
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextColor
                            : AppTheme.textColor),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600]),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail,
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextColor
                            : AppTheme.textColor),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600]),
                    ),
                    obscureText: true,
                    validator: FormValidators.validatePassword,
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextColor
                            : AppTheme.textColor),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline,
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600]),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        FormValidators.validateConfirmPassword(
                            value, _passwordController.text),
                    style: TextStyle(
                        color: isDark
                            ? AppTheme.darkTextColor
                            : AppTheme.textColor),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.darkTextSecondaryColor
                                : Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
