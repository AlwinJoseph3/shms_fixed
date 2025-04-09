import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_health_management/ui/screens/auth/login_screen.dart';
import 'package:smart_health_management/ui/screens/auth/register_screen.dart';
import 'package:smart_health_management/ui/screens/auth/forgot_password_screen.dart';
import 'package:smart_health_management/ui/screens/home.dart';
import 'package:smart_health_management/ui/screens/settings.dart';
import 'package:smart_health_management/ui/screens/user_files.dart';
import 'package:smart_health_management/ui/theme/app_theme.dart';

void main() async {
  try {
    // Ensure Flutter binding is initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Supabase
    await Supabase.initialize(
      url: "https://zlyenduzojxrdqodynuc.supabase.co",
      anonKey:
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpseWVuZHV6b2p4cmRxb2R5bnVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQwNDMyMDMsImV4cCI6MjA1OTYxOTIwM30.Ucxex9e5jd9rZbucVzh8e8_LnuH1Arcb0FrwyCbmceg",
    );

    runApp(const SmartHealthApp());
  } catch (e) {
    // Handle initialization errors
    debugPrint('Error initializing app: $e');
    // You might want to show an error screen or handle this differently
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class SmartHealthApp extends StatelessWidget {
  const SmartHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Health Management',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/user-files': (context) => const UserFilesScreen(),
      },
    );
  }
}
