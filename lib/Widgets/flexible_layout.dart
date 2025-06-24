import 'package:flutter/material.dart';

enum LayoutType { row, column }

class FlexibleLayout extends StatelessWidget {
  final LayoutType layoutType;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const FlexibleLayout({
    super.key,
    required this.layoutType,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final spacedChildren = _addSpacing(children, spacing);

    switch (layoutType) {
      case LayoutType.row:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: spacedChildren,
        );
      case LayoutType.column:
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: spacedChildren,
        );
    }
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (spacing <= 0.0 || children.length < 2) return children;
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) {
        spaced.add(SizedBox(
          width: layoutType == LayoutType.row ? spacing : 0,
          height: layoutType == LayoutType.column ? spacing : 0,
        ));
      }
    }
    return spaced;
  }
}
