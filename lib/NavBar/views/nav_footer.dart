import 'package:aiso/NavBar/widgets/footer_desktop.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FooterView extends StatelessWidget {
  const FooterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => const SizedBox.shrink(),
      tablet: (BuildContext context) => const SizedBox.shrink(),
      desktop: (BuildContext context) => FooterDesktop(),
    );
  }
}