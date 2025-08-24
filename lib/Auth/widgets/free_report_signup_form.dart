import 'package:aiso/routing/route_names.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:aiso/routing/app_router.dart';

class FreeReportSignUpForm extends StatefulWidget {
  const FreeReportSignUpForm({super.key});
  @override
  State<FreeReportSignUpForm> createState() => _FreeReportSignUpFormState();
}

class _FreeReportSignUpFormState extends State<FreeReportSignUpForm> {

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
    super.dispose();
  }

  // bool get isFormValid {
  //   final email = _emailController.text;
  //   final password = _passwordController.text;
  //   final confirmPassword = _confirmPasswordController.text;

  //   // Your business logic:
  //   if (email.isEmpty || !email.contains('@')) return false;
  //   if (password.length < 6) return false;
  //   if (password != confirmPassword) return false;
  //   return true;
  // }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authVm = context.read<AuthViewModel>();

    try {
      
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // final success = await authVm.signInOrSignUp(email, password);
      final success = await authVm.signUp(email, password);
      
      if (!mounted) return;

      if (success) {
        _showErrorSnackBar('Success!');
        appRouter.go(freeReportFormRoute);
      } else {
        _showErrorSnackBar(authVm.errorMessage ?? 'Something went wrong. Please try again');
      }
    } catch (e) {
      if (mounted) _showErrorSnackBar(authVm.errorMessage ?? 'Something went wrong. Please try again.');
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
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => setState(() {}),
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
                obscureText: _obscure,
                // onChanged: (_) => setState(() {}),
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
                autofillHints: const [AutofillHints.password],
                obscureText: _obscure,
                // onChanged: (_) => setState(() {}),
                onEditingComplete: () => TextInput.finishAutofillContext(),
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
                  onPressed:  _isLoading ? null : _signUp,
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
