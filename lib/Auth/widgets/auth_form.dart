// import 'package:aiso/Reports/view_models/reports_view_model.dart';
// import 'package:aiso/view_models/auth_view_model.dart';
// import 'package:aiso/views/auth/auth_checker_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AuthForm extends StatefulWidget {

//   const AuthForm({super.key});

//   @override
//   State<AuthForm> createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isSignIn = false;
//   final double _maxWidth = 400; 

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _toggleAuthMode() {
//     setState(() {
//       _isSignIn = !_isSignIn;
//     });
//   }

//   void _showErrorSnackBar(String message) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }

//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _isLoading = true);

//     try {
//       final authVm = context.read<AuthViewModel>();
//       final reportVm = context.read<ReportViewModel>();

//       final email = _emailController.text.trim();
//       final password = _passwordController.text;

//       final userId = await authVm.signIn(email, password);
//       if (!mounted) return;
//       if (userId == null) {
//         _showErrorSnackBar('Sign-in failed');
//         return;
//       }

//       final loaded = await reportVm.signinFetchAll(userId);
//       if (!mounted) return;
//       if (!loaded) {
//         _showErrorSnackBar('Couldn’t load your data');
//         return;
//       }

//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => AuthChecker()),
//         (_) => false,
//       );
//     } catch (e) {
//       if (mounted) _showErrorSnackBar('Oops, something went wrong');
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }


//   void _submit() {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     // TODO: implement your sign-in or sign-up logic here
//     if (_isSignIn) {
//       // handle sign in
//       _signIn()
//     } else {
//       // handle sign up
//     }
//   } 

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: _maxWidth),
//           child: TextField(
//             controller: _emailController,
//             decoration: const InputDecoration(
//               labelText: 'Email',
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             ),
//             autofillHints: const [AutofillHints.email],
//           ),
//         ),
//         const SizedBox(height: 16),
//         ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: _maxWidth),
//           child: TextField(
//             controller: _passwordController,
//             decoration: const InputDecoration(
//               labelText: 'Password',
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//             ),
//             obscureText: true,
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width: _maxWidth,
//           child: ElevatedButton(
//             onPressed: _submit,
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.black,
//             ),
//             child: Text(_isSignIn ? 'Sign In' : 'Sign Up'),
//           ),
//         ),
//         const SizedBox(height: 16),
//         SizedBox(
//           width:_maxWidth,
//           child: TextButton(
//             onPressed: _toggleAuthMode,
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(fontSize: 14.0, color: Colors.black87),
//                 children: [
//                   TextSpan(
//                     text: _isSignIn
//                         ? "Don't have an account? "
//                         : "Already have an account? ",
//                   ),
//                   TextSpan(
//                     text: _isSignIn ? "Sign up, it's free!" : "Sign in!",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:aiso/Reports/view_models/reports_view_model.dart';
import 'package:aiso/Reports/views/reports_view.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/views/auth/auth_checker_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = false;
  bool _isLoading = false;
  final double _maxWidth = 400;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authVm   = context.read<AuthViewModel>();
      final reportVm = context.read<ReportViewModel>();

      final email    = _emailController.text.trim();
      final password = _passwordController.text;

      final userId = await authVm.signIn(email, password);
      if (!mounted) return;
      if (userId == null) {
        _showErrorSnackBar('Sign-in failed. Check your credentials.');
        return;
      }

      final loaded = await reportVm.signinFetchAll(userId);
      if (!mounted) return;
      if (!loaded) {
        _showErrorSnackBar('Signed in, but failed to load your data.');
        return;
      }

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (_) => const AuthChecker()),
      //   (_) => false,
      // );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MyReports()),
      );

    } catch (e) {
      if (mounted) _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authVm   = context.read<AuthViewModel>();
      final reportVm = context.read<ReportViewModel>();

      final email    = _emailController.text.trim();
      final password = _passwordController.text;

      final success = await authVm.signUp(email, password);
      if (!mounted) return;

      if (success) {
        _showErrorSnackBar('Signup successful! Check your email to verify.');
        // Optionally clear previous reports:
        reportVm.clearReports();
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => AuthChecker()),
        //   (route) => false,
        // );
      } else {
        _showErrorSnackBar(authVm.errorMessage ?? 'Signup failed.');
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submit() async {
    if (_isSignIn) {
      await _signIn();
    } else {
      await _signUp();
    }
    locator<NavigationService>().navigateTo(ReportsRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxWidth),
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              autofillHints: const [AutofillHints.email],
              validator: (val) {
                if (val == null || val.isEmpty) return 'Email required';
                if (!val.contains('@'))         return 'Enter a valid email';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: _maxWidth),
            child: TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              obscureText: true,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Password required';
                if (val.length < 6)               return 'Min 6 characters';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: _maxWidth,
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(_isSignIn ? 'Sign In' : 'Sign Up'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: _maxWidth,
            child: TextButton(
              onPressed: _isLoading ? null : _toggleAuthMode,
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
        ],
      ),
    );
  }
}
