import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aiso/routing/app_router.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final double _maxWidth = 400;

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

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final authVm   = context.read<AuthViewModel>();
      // final reportVm = context.read<ReportsViewModel>();

      final email    = _emailController.text.trim();
      final password = _passwordController.text;

      final success = await authVm.signUp(email, password);
      appRouter.go(verifyEmailRoute);
      
      if (!mounted) return;

      if (success) {
        _showErrorSnackBar('Signup successful! Check your email to verify.');
      } else {
        _showErrorSnackBar(authVm.errorMessage ?? 'Signup failed.');
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                if (!val.contains('@')) return 'Enter a valid email';
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
                if (val.length < 6) return 'Min 6 characters';
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          // SizedBox(
          //   width: _maxWidth,
          //   height: 48,
          //   child: 
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: _maxWidth, minHeight: 48, maxHeight: 60),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Sign Up'),
              ),
            ),
          // ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
