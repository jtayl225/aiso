import 'package:aiso/Auth/widgets/signup_details.dart';
import 'package:aiso/Auth/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignUpMobile extends StatelessWidget {
  const SignUpMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignUpDetails(isCentered: true),
        SizedBox(height:30),
        Center(child: SignUpForm()),
      ],
    );
  }
}
