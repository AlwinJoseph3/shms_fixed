import 'package:flutter/material.dart';
import 'package:smart_health_management/core/theme.dart';
import 'package:smart_health_management/ui/widgets/loading_overlay.dart';
import 'package:smart_health_management/utils/form_validators.dart';
import 'auth_service.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response.user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = "Invalid email or password";
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


  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Mock Google sign in - replace with actual implementation later
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
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

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Mock Apple sign in - replace with actual implementation later
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  Text(
                    'SHMS',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 70,
                          color: isDark
                              ? AppTheme.darkTextColor
                              : AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isDark
                              ? AppTheme.darkTextSecondaryColor
                              : Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
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
                    onPressed: _signInWithEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //         child: Divider(
                  //             color: isDark
                  //                 ? AppTheme.darkDividerColor
                  //                 : Colors.grey[300])),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       child: Text(
                  //         'OR',
                  //         style: TextStyle(
                  //             color: isDark
                  //                 ? AppTheme.darkTextSecondaryColor
                  //                 : Colors.grey[600]),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Divider(
                  //             color: isDark
                  //                 ? AppTheme.darkDividerColor
                  //                 : Colors.grey[300])),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),
                  // OutlinedButton.icon(
                  //   onPressed: _signInWithGoogle,
                  //   icon: Image.network(
                  //     'https://www.google.com/favicon.ico',
                  //     height: 24,
                  //     width: 24,
                  //   ),
                  //   label: const Text('Continue with Google'),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 16),
                  //     side: BorderSide(
                  //         color: isDark
                  //             ? AppTheme.darkDividerColor
                  //             : Colors.grey[300]!),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // OutlinedButton.icon(
                  //   onPressed: _signInWithApple,
                  //   icon: Icon(Icons.apple,
                  //       color: isDark
                  //           ? AppTheme.darkTextColor
                  //           : AppTheme.textColor),
                  //   label: Text('Continue with Apple',
                  //       style: TextStyle(
                  //           color: isDark
                  //               ? AppTheme.darkTextColor
                  //               : AppTheme.textColor)),
                  //   style: OutlinedButton.styleFrom(
                  //     padding: const EdgeInsets.symmetric(vertical: 16),
                  //     side: BorderSide(
                  //         color: isDark
                  //             ? AppTheme.darkDividerColor
                  //             : Colors.grey[300]!),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            color: isDark
                                ? AppTheme.darkTextSecondaryColor
                                : Colors.grey[600]),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
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
