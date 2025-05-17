import 'dart:math';
import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/constants/buttons_constants.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    final success = await authViewModel.signUp(email, password);

    if (success) {
      // Optionally navigate or show success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful! Please check your email.')),
      );
      authViewModel.setAuthScreenState(AuthScreenState.welcome);
      // // Navigate or reset form, e.g. Navigator.pop(context);
      // Future.delayed(const Duration(seconds: 1), () {
      //   Navigator.pushReplacementNamed(context, '/');
      // });
    } else {
      // Show error from view model
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authViewModel.errorMessage ?? 'Signup failed')),
      );
    }

  }

  void _goToSignIn(BuildContext context) {
    context.read<AuthViewModel>().setAuthScreenState(AuthScreenState.signIn);
  }

  @override
  Widget build(BuildContext context) {
    
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = ButtonDimensions.getWidth(ButtonSize.large);
    double buttonHeight = ButtonDimensions.getHeight(ButtonSize.small);
    double maxButtonWidth = min(buttonWidth, screenWidth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 32),
            
                Image.asset(
                    logoImage,
                    width: 200.0,
                    height: 200.0,
                  ),
                  
                const SizedBox(height: 16),
                
                // Welcome Message
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.color1,
                  ),
                ),
                
                // Subheading with instructions
                const SizedBox(height: 8),
                
                const Text(
                  'Please create an account to continue',
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
            
                // TextField(
                //   controller: _emailController,
                //   decoration: const InputDecoration(labelText: 'Email'),
                // ),
            
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
            
                // TextField(
                //   controller: _passwordController,
                //   decoration: const InputDecoration(labelText: 'Password'),
                //   obscureText: true,
                // ),
            
                const SizedBox(height: 16),
            
                SizedBox(
                  height: buttonHeight,
                  width: maxButtonWidth,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.color1, // This sets the text color
                    ),
                    child: const Text('Sign Up'),
                  ),
                ),
            
                // ElevatedButton(
                //   onPressed: _signUp,
                //   child: const Text('Sign Up'),
                // ),
            
                const SizedBox(height: 16),
            
                SizedBox(
                    width: maxButtonWidth,
                    child: TextButton(
                      onPressed: () => _goToSignIn(context),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: AppColors.color2,
                          ),
                          children: [
                            const TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "Sign in!",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            
                // TextButton(
                //   onPressed: () => _goToSignIn(),
                //   child: const Text("Already have an account? Sign in!"),
                // ),
            
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
