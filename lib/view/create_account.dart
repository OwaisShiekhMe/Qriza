import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qriza/reusable_component/app_scaffold.dart';
import 'package:qriza/reusable_component/custom_button.dart';
import 'package:qriza/reusable_component/custom_input.dart';
import 'package:qriza/view/login_screen.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  late double screenWidth;
  late double screenHeight;
  late TextScaler textScaler;
  final formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    textScaler = MediaQuery.of(context).textScaler;
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Image.asset(
          'images/logo.png',
          width: screenWidth * 0.3,
          height: screenHeight * 0.1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            stepCount(),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: textScaler.scale(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: Text(
                'Setup you Qriza account in just two steps',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontSize: textScaler.scale(16),
                    color: Color(0xff424656),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomInput(
                    hint: 'John Doe',
                    label: 'Full Name',
                    controller: fullNameController,
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hint: 'john.doe@gmail.com',
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
                  SizedBox(height: screenHeight * 0.02),
                  CustomInput(
                    hint: 'Confirm your password',
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text.rich(
              TextSpan(
                text: 'Already have an account? ',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    fontSize: textScaler.scale(14),
                    color: Color(0xff424656),
                  ),
                ),
                children: [
                  TextSpan(
                    text: 'Sign In',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        fontSize: textScaler.scale(14),
                        color: Color(0xff0050CB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: LoginScreen(),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            CustomButton(
              label: "Continue",
              onTap: () {
                if (formKey.currentState!.validate()) {
                  // Proceed to the next step of account creation
                }
              },
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  Widget stepCount() {
    return Container(
      height: screenHeight * 0.05,
      width: screenWidth * 0.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenWidth * 0.08),
        color: Color(0xff60F8CB),
      ),
      child: Text(
        "Step 1 of 2",
        style: GoogleFonts.plusJakartaSans(
          textStyle: TextStyle(
            fontSize: textScaler.scale(14),
            color: Color(0xff007057),
          ),
        ),
      ),
    );
  }
}
