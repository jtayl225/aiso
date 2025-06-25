import 'package:aiso/constants/string_constants.dart';
import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {

  const NavBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 150.0, maxWidth: 300.0),
      child: Image.asset(logoImage),
    );
  }
}