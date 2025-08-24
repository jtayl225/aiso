import 'package:aiso/constants/app_colors.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;
  final double _maxWidth = 400;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.color3,
      ),
    );
  }

  Future<void> _signUp() async {

    if (!_formKey.currentState!.validate()) return;

    // Save autofill data before signing in
    TextInput.finishAutofillContext(shouldSave: true);

    setState(() => _isLoading = true);

    try {
      final authVm   = context.read<AuthViewModel>();
      // final reportVm = context.read<ReportsViewModel>();

      final email    = _emailController.text.trim();
      final password = _passwordController.text;

      final success = await authVm.signUp(email, password);
      // appRouter.go(verifyEmailRoute);
      // appRouter.go(reportsRoute);
      
      if (!mounted) return;

      if (success) {
        _showSuccessSnackBar('Signup successful! Check your email to verify.');
        appRouter.go(reportsRoute);
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
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth),
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                obscureText: _obscure,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password required';
                  if (val.length < 6) return 'Min 6 characters';
                  return null;
                },
              ),
            ),
        
            const SizedBox(height: 16),
        
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxWidth),
              child: TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                obscureText: _obscure,
                // onEditingComplete: () => TextInput.finishAutofillContext(),
                onFieldSubmitted: (_) => _signUp(),
                // onChanged: (_) => setState(() {}),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Password required';
                  if (val.length < 6) return 'Min 6 characters';
                  if (val != _passwordController.text) return 'Passwords do not match';
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
                      : Text('Go'),
                ),
              ),
            // ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
