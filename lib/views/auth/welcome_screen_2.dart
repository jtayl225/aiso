import 'dart:math';

import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/constants/buttons_constants.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/view_models/reports_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:aiso/views/generate_free_report_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen2 extends StatefulWidget {
  const WelcomeScreen2({super.key});

  @override
  State<WelcomeScreen2> createState() => _WelcomeScreenState2();
}

class _WelcomeScreenState2 extends State<WelcomeScreen2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignIn = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _submit() {
    if (_isSignIn) {
      _signIn();
    } else {
      _signUp();
    }
  }

  Future<void> _signIn() async {
    debugPrint('Sign in with: ${_emailController.text}, ${_passwordController.text}');
    final authViewModel = context.read<AuthViewModel>();
    final reportViewModel = context.read<ReportViewModel>();

    try {

      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final currentUserId = await authViewModel.signIn(email, password);

      if (currentUserId == null) {
        _showErrorSnackBar('Sign-in failed. Please check your credentials.');
        return;
      }

      debugPrint('DEBUG: before reportViewModel.signinFetchAll');
      final fetchSuccess = await reportViewModel.signinFetchAll(currentUserId);
      debugPrint('DEBUG: after reportViewModel.signinFetchAll.');

      if (!fetchSuccess) {
        _showErrorSnackBar('Signed in, but failed to load your data.');
        return;
      }

      // authViewModel.setAuthScreenState(AuthScreenState.welcome);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => AuthChecker()),
        (route) => false,
      );

    } catch (e, stackTrace) {
      debugPrint('Sign-in error: $e\n$stackTrace');
      _showErrorSnackBar('Something went wrong. Please try again.');
    }
  }

  Future<void> _signUp() async {
    debugPrint('Sign up with: ${_emailController.text}, ${_passwordController.text}');
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final reportViewModel = context.read<ReportViewModel>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Email and password cannot be empty.');
      return;
    }

    final success = await authViewModel.signUp(email, password);
    if (success) {
      _showErrorSnackBar('Signup successful! Please check your email.');
    } else {
      _showErrorSnackBar(authViewModel.errorMessage ?? 'Signup failed');
    }

    reportViewModel.clearReports();

  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = ButtonDimensions.getWidth(ButtonSize.large);
    // double buttonHeight = ButtonDimensions.getHeight(ButtonSize.small);
    double maxButtonWidth = min(buttonWidth, screenWidth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                logoImage,
                width: 200.0,
                height: 200.0,
              ),
              
              const SizedBox(height: 16),
              
              // // Welcome Message
              // const Text(
              //   'Welcome!',
              //   style: TextStyle(
              //     fontSize: 24.0,
              //     fontWeight: FontWeight.bold,
              //     color: AppColors.color2,
              //   ),
              // ),
              
              // // Subheading with instructions
              // const SizedBox(height: 8),

              // Continue as Guest button
              SizedBox(
                width: maxButtonWidth,
                child: ElevatedButton(
                  onPressed: () {
                    debugPrint("DEBUG: Generate free report pressed!");
                    // TODO: Implement your guest logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AgentFormScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, // 👈 sets the text/icon color
                  ),
                  child: const Text('Generate free report!'),
                ),
              ),
              const SizedBox(height: 24),

              // OR Divider
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxButtonWidth),
                child: Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text('OR', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 24),


              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxButtonWidth),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  autofillHints: [AutofillHints.email],
                ),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxButtonWidth),
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                // height: buttonHeight,
                width: maxButtonWidth,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, // 👈 sets the text/icon color
                  ),
                  child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: maxButtonWidth,
                child: TextButton(
                  onPressed: _toggleAuthMode,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                      children: [
                        TextSpan(
                          text: _isSignIn
                              ? "Don't have an account? "
                              : "Already have an account? ",
                        ),
                        TextSpan(
                          text: _isSignIn ? "Sign up, it's free!" : "Sign in!",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
