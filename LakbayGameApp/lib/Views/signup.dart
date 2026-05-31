import 'package:flutter/material.dart';
import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Components/textfield.dart';
import 'package:lakbay_game/Views/login.dart';
import 'package:lakbay_game/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final gender = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;

  Future<void> createAccount() async {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await _authService.createAccount(
      name: fullName.text.trim(),
      email: email.text.trim(),
      gender: gender.text.trim(),
      password: password.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to create account')));
    }
  }

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    gender.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      // Logo
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Image.asset(
                          'assets/startup.png',
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      // Full Name
                      InputField(
                        hint: 'Full Name',
                        icon: Icons.person,
                        controller: fullName,
                        passwordInvisible: false,
                      ),

                      // Email
                      InputField(
                        hint: 'Email',
                        icon: Icons.email,
                        controller: email,
                        passwordInvisible: false,
                      ),

                      // Gender Dropdown
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonFormField<String>(
                          initialValue: gender.text.isEmpty
                              ? null
                              : gender.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(Icons.person),
                          ),
                          hint: const Text('Gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              gender.text = value!;
                            });
                          },
                        ),
                      ),

                      // Password
                      InputField(
                        hint: 'Password',
                        icon: Icons.lock,
                        controller: password,
                        passwordInvisible: true,
                      ),

                      // Confirm Password
                      InputField(
                        hint: 'Confirm Password',
                        icon: Icons.lock,
                        controller: confirmPassword,
                        passwordInvisible: true,
                      ),

                      const SizedBox(height: 20),

                      _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Button(
                              label: 'CREATE AN ACCOUNT',
                              press: createAccount,
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 10, 27),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
