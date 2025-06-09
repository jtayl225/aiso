import 'package:aiso/constants/string_constants.dart';
import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {

  const NavBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 300,
      child: Image.asset(logoImage),
    );
  }
}