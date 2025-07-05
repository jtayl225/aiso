
import 'package:aiso/Auth/widgets/signup_details.dart';
import 'package:aiso/Auth/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class SignUpDesktop extends StatelessWidget {
  const SignUpDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [SignUpDetails(isCentered: false), Spacer(), SignUpForm()],
    );
  }
}
