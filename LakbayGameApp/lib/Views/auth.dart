import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lakbay_game/Components/button.dart';
import 'package:lakbay_game/Views/login.dart';
import 'package:lakbay_game/Views/signup.dart';
import 'package:lakbay_game/config/api_config.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  List weatherData = [];

  @override
  void initState() {
    super.initState();

    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
    final response = await http.get(
  Uri.parse('${ApiConfig.baseUrl}/weatherforecast'),
);
      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {
          weatherData = data;
        });

        print(weatherData);

      } else {
        print('Failed to load weather');
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // Logo
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Image.asset(
                          'assets/startup.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Button(
                      label: 'CREATE AN ACCOUNT',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                    ),

                    Button1(
                      label: 'LOG IN',
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    // Sample display from API
                    if (weatherData.isNotEmpty)
                      Text(
                        weatherData[0]['summary'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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