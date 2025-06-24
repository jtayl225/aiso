import 'package:aiso/Auth/widgets/auth_details.dart';
import 'package:aiso/Auth/widgets/auth_form.dart';
import 'package:flutter/material.dart';

class AuthHomeMobile extends StatelessWidget {

  const AuthHomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
                children: [
                  AuthDetails(isCentered: true),
                  Expanded(
                    child: Center(
                      child: AuthForm(),
                    ),
                  )
                ]
              );
  }
}