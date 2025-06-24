import 'package:flutter/material.dart';

class AuthDetails extends StatelessWidget {

  final bool isCentered;

  const AuthDetails({super.key, required this.isCentered});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign up.',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 80, height: 0.9),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Sign up or sign in to continue.\nIt\'s free to create an account!',
            style: TextStyle(fontSize: 21, height: 1.7),
            textAlign: isCentered ? TextAlign.center : TextAlign.start,
          ),
        ],
      ),
    );
  }
}