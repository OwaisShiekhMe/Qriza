import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qriza/reusable_component/app_scaffold.dart';
import 'package:qriza/reusable_component/custom_button.dart';
import 'package:qriza/reusable_component/custom_input.dart';
import 'package:qriza/view/create_account.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.07),
            Image.asset(
              'images/logo.png',
              width: 100.0.clamp(100.0, 200.0),
              height: 100.0.clamp(100.0, 200.0),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Welcome Back!',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontSize: textScaler.scale(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              'Sign in to manage your payment  QR',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  fontSize: textScaler.scale(16),
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomInput(
                    hint: 'Enter your email',
                    label: 'Email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hint: 'Enter your password',
                    label: 'Password',
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.01,
                right: screenWidth * 0.05,
              ),
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontSize: textScaler.scale(14),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            CustomButton(
              label: "Sign In",
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  print('Email: ${emailController.text}');
                  print('Password: ${passwordController.text}');
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[400]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    child: Text(
                      'OR',
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                          fontSize: textScaler.scale(14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            CustomButton(
              label: "Create Account",
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CreateAccount(),
                  ),
                );
              },
              outlineButton: true,
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
