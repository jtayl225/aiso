import 'package:aiso/Auth/widgets/auth_details.dart';
import 'package:aiso/Auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthHomeDesktop extends StatelessWidget {
  const AuthHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AuthDetails(isCentered: false),
                  Spacer(),
                  AuthForm()
              ]);
  }
}