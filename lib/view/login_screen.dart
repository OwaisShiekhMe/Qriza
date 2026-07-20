import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qriza/di/injection_container.dart';
import 'package:qriza/reusable_component/app_scaffold.dart';
import 'package:qriza/reusable_component/custom_button.dart';
import 'package:qriza/reusable_component/custom_input.dart';
import 'package:qriza/services/api_service.dart';
import 'package:qriza/view/account_details.dart';
import 'package:qriza/view/create_account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qriza/view_model/user_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userViewModelProvider);
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
            userState.isLoading
                ? CircularProgressIndicator()
                : CustomButton(
                  label: "Sign In",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(userViewModelProvider.notifier)
        .login(emailController.text.trim(), passwordController.text.trim());

    if (!mounted) {
      return; // Check if the widget is still mounted before showing a snackbar
    }

    if (result['success'] == true) {
      final String status = result['status'];
      final String userId = result['userId'] ?? '';

      if (status == 'PAYMENT') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AccountDetails(),
            settings: RouteSettings(arguments: userId),
          ),
        );
      } else {
        print("Dashboard");
      }
    } else {
      final String error = result['error'] ?? 'An unknown error occurred';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _handleLoginSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final authService =
        sl<ApiService>(); // Assuming you have a service locator for AuthService
    try {
      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in both email and password.')),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });
      final result = await authService.loginAndCheckStatus(
        email: email,
        password: password,
      );

      if (result['status'] == 'PAYMENT') {
        // Navigate to the payment screen
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: AccountDetails(), // Replace with your payment screen
          ),
        );
      } else if (result['status'] == 'SUCCESS') {
        // Navigate to the main app screen
        // Navigator.pushReplacement(
        //   context,
        //   PageTransition(
        //     type: PageTransitionType.rightToLeft,
        //     child: CreateAccount(), // Replace with your main app screen
        //   ),
        // );
        print('Dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Simple toast helper
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }
}
