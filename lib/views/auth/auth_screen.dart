
// import 'package:aiso/views/auth/signin_screen.dart';
// import 'package:aiso/views/auth/signup_screen.dart';
// import 'package:aiso/views/auth/welcome_screen.dart';
// import 'package:aiso/views/auth/welcome_screen_2.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../view_models/auth_view_model.dart';
// import '../../models/auth_state_enum.dart';

// class AuthScreen extends StatelessWidget {
//   const AuthScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenState = context.watch<AuthViewModel>().authScreenState;

//     switch (screenState) {
//       case AuthScreenState.welcome:
//         return const WelcomeScreen2(); // WelcomeScreen();
//       case AuthScreenState.signIn:
//         return const SignInScreen();
//       case AuthScreenState.signUp:
//         return const SignUpScreen();
//     }
//   }
// }
