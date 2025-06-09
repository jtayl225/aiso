import 'package:aiso/Store/widgets/store_desktop.dart';
import 'package:aiso/Store/widgets/store_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyStore extends StatelessWidget {
  const MyStore({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => StoreMobile(),
      tablet: (BuildContext context) => StoreMobile(),
      desktop: (BuildContext context) => StoreDesktop(),
    );
  }
}