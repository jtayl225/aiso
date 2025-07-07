import 'package:aiso/NavBar/widgets/markdown_viewer.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  final String verifyEmailText = """
# **Thank you!**

## Verify Your Email Address

Thank you for creating an account!

To activate your account and get started, please check your inbox for a verification email. We've sent a link to the email address you provided.

## What to do next:

* Find the Email: Look for an email from GEO MAX with the subject line "Confirm Your Signup - GEOMAX".

* Click the Link: Open the email and click on the verification link inside.

* You're All Set! Once you click the link, your account will be activated, and you'll be ready to explore GEO MAX.

## Didn't receive the email?

* Please check your spam or junk folder.

* Make sure the email address you registered with is correct.

If you continue to experience issues, please contact our support team at [Support Email].
""";

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => MarkdownViewer(markdownText: verifyEmailText, deviceType: DeviceScreenType.mobile),
      tablet: (BuildContext context) => MarkdownViewer(markdownText: verifyEmailText, deviceType: DeviceScreenType.mobile),
      desktop: (BuildContext context) => MarkdownViewer(markdownText: verifyEmailText, deviceType: DeviceScreenType.desktop),
    );
  }
}