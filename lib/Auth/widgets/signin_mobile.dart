import 'package:aiso/Auth/widgets/sigin_details.dart';
import 'package:aiso/Auth/widgets/signin_form.dart';
import 'package:flutter/material.dart';

class SignInMobile extends StatelessWidget {
  const SignInMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SignInDetails(isCentered: true),
        SizedBox(height:30),
        Center(child: SignInForm()),
      ],
    );
  }
}
