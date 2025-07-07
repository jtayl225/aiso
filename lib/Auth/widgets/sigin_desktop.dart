import 'package:aiso/Auth/widgets/sigin_details.dart';
import 'package:aiso/Auth/widgets/signin_form.dart';
import 'package:flutter/material.dart';

class SignInDesktop extends StatelessWidget {
  const SignInDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 1000, minHeight: 600),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [SignInDetails(isCentered: false), Spacer(), SignInForm()],
      ),
    );
  }
}
