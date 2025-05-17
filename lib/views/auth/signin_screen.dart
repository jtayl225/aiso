import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/constants/buttons_constants.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/view_models/reports_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  Future<void> _signIn() async {
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

      authViewModel.setAuthScreenState(AuthScreenState.welcome);

    } catch (e, stackTrace) {
      debugPrint('Sign-in error: $e\n$stackTrace');
      _showErrorSnackBar('Something went wrong. Please try again.');
    }
  }

  void _goToSignUp(BuildContext context) {
    context.read<AuthViewModel>().setAuthScreenState(AuthScreenState.signUp);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = ButtonDimensions.getWidth(ButtonSize.large);
    double buttonHeight = ButtonDimensions.getHeight(ButtonSize.small);
    double maxButtonWidth = min(buttonWidth, screenWidth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, 
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              
                  // Spacer(),
                  const SizedBox(height: 32),
                      
                  Image.asset(
                    logoImage,
                    width: 200.0,
                    height: 200.0,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Welcome Message
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.color1,
                    ),
                  ),
                  
                  // Subheading with instructions
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppColors.color2,
                    ),
                  ),
                      
                  const SizedBox(height: 32),
                      
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxButtonWidth,
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                      obscureText: false,
                      autofillHints: [AutofillHints.email],
                    ),
                  ),
                      
                  const SizedBox(height: 16),
                      
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxButtonWidth,
                    ),
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
                    height: buttonHeight,
                    width: maxButtonWidth,
                    child: ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.color1, // This sets the text color
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                      
                  const SizedBox(height: 16),
                      
                  // SizedBox(
                  //   // height: buttonHeight,
                  //   width: maxButtonWidth,
                  //   child: TextButton(
                  //     onPressed: () => _goToSignUp(),
                  //     child: const Text("Don't have an account? Sign up, it's free!"),
                  //   ),
                  // ),
                      
                  SizedBox(
                    width: maxButtonWidth,
                    child: TextButton(
                      onPressed: () => _goToSignUp(context),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.color2,
                          ),
                          children: [
                            const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "Sign up, it's free!",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                      
                  // const SizedBox(height: 50),
                  const SizedBox(height: 32),
                  // Spacer(),
                      
                ],
              ),
            ),
          ),
        ),
      );
  }
}