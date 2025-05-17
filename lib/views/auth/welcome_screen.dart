import 'dart:math';
import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/constants/buttons_constants.dart';
import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/models/auth_state_enum.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _goToSignIn(BuildContext context) {
    context.read<AuthViewModel>().setAuthScreenState(AuthScreenState.signIn);
  }

  void _goToSignUp(BuildContext context) {
    context.read<AuthViewModel>().setAuthScreenState(AuthScreenState.signUp);
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = ButtonDimensions.getWidth(ButtonSize.large);
    // double buttonHeight = ButtonDimensions.getHeight(ButtonSize.small);
    double maxButtonWidth = min(buttonWidth, screenWidth);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            
                Spacer(),
                // const SizedBox(height: 64),
                    
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
                  'Please sign in or sign up to continue',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxButtonWidth / 2.1,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            _goToSignIn(context);
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide(color: Colors.black, width: 1.0)), // Border properties
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))), // Optional: Rounded corners
                          ),
                          child: const Text(
                            'Signin',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.color1,
                            ),
                          ),
                        ),
                      ),
                  
                      Spacer(),
                  
                      SizedBox(
                        width: maxButtonWidth / 2.1,
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            _goToSignUp(context);
                          },
                          style: ButtonStyle(
                            side: WidgetStateProperty.all(BorderSide(color: Colors.black, width: 1.0)), // Border properties
                            shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))), // Optional: Rounded corners
                          ),
                          child: const Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.color1,
                            ),
                          ),
                        ),
                      ),
                  
                  
                    ],
                  ),
                ),
                    
                // const SizedBox(height: 50),
                // const SizedBox(height: 32),
                Spacer(),
                    
              ],
            ),
          ),
        ),
      );
  }
}