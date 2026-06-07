import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Components/textfield.dart';
import 'package:lakbay_game/Views/profile.dart';
import 'package:lakbay_game/Views/signup.dart';
import 'package:lakbay_game/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userName = TextEditingController(
    text: 'John Doe',
  ); // Default value for testing, remove in production
  final password = TextEditingController(
    text: '12345',
  ); // Default value for testing, remove in production

  final AuthService authService = AuthService();

  bool isChecked = false;
  bool isLoginTrue = false;
  bool obscurePassword = true;

  Future<void> handleLogin() async {
    bool success = await authService.login(
      userName: userName.text.trim(),
      password: password.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoginTrue = !success;
    });

    if (success) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/background.png', // change to your image
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 👇 Responsive Logo (NOT Expanded)
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.8, // 60% of screen width
                        child: Image.asset(
                          'assets/startup.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    TextField(
                      controller: userName,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        prefixIcon: const Icon(Icons.account_circle),
                      ),
                    ),
                    TextField(
                      controller: password,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
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
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      title: const Text(
                        'Remember Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    Button1(
                      label: 'LOG IN',
                      press: () async {
                        await handleLogin();
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 10, 27),
                            ),
                          ),
                        ),
                      ],
                    ),

                    isLoginTrue
                        ? Text(
                            'Username or password is incorect',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 172, 4, 4),
                            ),
                          )
                        : const SizedBox(),
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
