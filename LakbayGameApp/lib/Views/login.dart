import 'package:flutter/material.dart';
import 'package:lakbay_game/Views/profile.dart';
import 'package:lakbay_game/Views/signup.dart';
import 'package:lakbay_game/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userName = TextEditingController(text: 'John Doe');
  final password = TextEditingController(text: '12345');

  final AuthService authService = AuthService();

  bool isChecked = false;
  bool isLogin = false;
  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      isLogin = false;
    });

    final success = await authService.login(
      userName: userName.text.trim(),
      password: password.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      isLogin = !success;
    });

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  void dispose() {
    userName.dispose();
    password.dispose();
    super.dispose();
  }

  InputDecoration modernInput(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.9),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          Container(color: Colors.black.withValues(alpha: 0.4)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    Image.asset('assets/startup.png', width: 180),

                    const SizedBox(height: 30),

                    // LOGIN CARD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: userName,
                            enabled: !isLoading,
                            decoration: modernInput(
                              'Username',
                              Icons.account_circle,
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: password,
                            enabled: !isLoading,
                            obscureText: obscurePassword,
                            decoration: modernInput('Password', Icons.lock)
                                .copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                              ),
                              const Text(
                                'Remember Me',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // LOGIN BUTTON WITH SPINNER
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  10,
                                  27,
                                ),
                              ),
                              onPressed: isLoading ? null : handleLogin,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "LOG IN",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          if (isLogin)
                            const Text(
                              'Incorrect username or password',
                              style: TextStyle(color: Colors.redAccent),
                            ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignupScreen(),
                                          ),
                                        );
                                      },
                                child: const Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
