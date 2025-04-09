import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password, {String? fullName}) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName,
      },
    );
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _supabase.auth
        .signInWithPassword(email: email, password: password);
    return response;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}

void testSupabaseAuth() async {
  final authService = AuthService();
  try {
    // Sign up a new user
    final signUpResponse =
        await authService.signUp('test@example.com', 'password123');
    print('Sign Up Response: ${signUpResponse.user?.email}');

    // Sign in with the same credentials
    final signInResponse =
        await authService.signIn('test@example.com', 'password123');
    print('Sign In Response: ${signInResponse.user?.email}');

    // Check if the user is logged in
    final currentUser = authService.currentUser;
    print('Current User: ${currentUser?.email}');

    // Sign out
    await authService.signOut();
    print('User signed out');
  } catch (e) {
    print('Error: $e');
  }
}
