import 'package:aiso/constants/font_sizes.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:flutter/material.dart';

class SignInDetails extends StatelessWidget {
  final bool isCentered;

  const SignInDetails({super.key, required this.isCentered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        crossAxisAlignment:
            isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign in.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: fontSizeDesktopLarge,
              height: 0.9,
            ),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: 30),
          Text(
            'If you already have a GEO MAX account, you can sign in here.',
            style: TextStyle(fontSize: fontSizeDesktopMedium, height: 1.7),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: 30),
          TextButton(
            // onPressed: appRouter.go(signUpRoute),
            style: TextButton.styleFrom(
              padding:
                  EdgeInsets.zero, // Removes default 16px horizontal padding
              alignment: Alignment.centerLeft, // Aligns content to the left
              tapTargetSize:
                  MaterialTapTargetSize
                      .shrinkWrap, // Optional: makes hitbox smaller
            ),
            onPressed: () => appRouter.go(signUpRoute),
            child: RichText(
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
              text: TextSpan(
                style: DefaultTextStyle.of(
                  context,
                ).style.copyWith(fontSize: fontSizeDesktopMedium),
                children: [
                  TextSpan(text: 'If you want to create a new account, '),
                  TextSpan(
                    text: 'click here.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
