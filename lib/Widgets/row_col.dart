import 'package:flutter/material.dart';

enum RowColType { row, column }

class RowCol extends StatelessWidget {
  final RowColType layoutType;
  final List<Widget> children;
  final List<int>? flexes;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment colMainAxisAlignment;
  final CrossAxisAlignment colCrossAxisAlignment;
  final double spacing;

  const RowCol({
    super.key,
    required this.layoutType,
    required this.children,
    this.flexes,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.colMainAxisAlignment = MainAxisAlignment.start,
    this.colCrossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {

    final wrappedChildren = _wrapChildrenForLayout(children);
    final spacedChildren = _addSpacing(wrappedChildren, spacing);

    switch (layoutType) {
      case RowColType.row:
        return Row(
          mainAxisAlignment: rowMainAxisAlignment,
          crossAxisAlignment: rowCrossAxisAlignment,
          children: spacedChildren,
        );
      case RowColType.column:
        return Column(
          mainAxisAlignment: colMainAxisAlignment,
          crossAxisAlignment: colCrossAxisAlignment,
          children: spacedChildren,
        );
    }
  }

  // List<Widget> _wrapChildrenForLayout(List<Widget> children) {
  //   if (layoutType == RowColType.row) {
  //     return List.generate(children.length, (i) {
  //       final flex = flexes != null && flexes!.length > i ? flexes![i] : 1;
  //       return Flexible(flex: flex, fit: FlexFit.tight, child: children[i]);
  //     });
  //   } else {
  //     return children;
  //   }
  // }

  List<Widget> _wrapChildrenForLayout(List<Widget> children) {
    if (layoutType == RowColType.row) {
      return List.generate(children.length, (i) {
        final flex = flexes != null && flexes!.length > i ? flexes![i] : 1;
        return Expanded(
          flex: flex,
          child: children[i],
        );
      });
    } else {
      return children;
    }
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (spacing <= 0.0 || children.length < 2) return children;
    final spaced = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i != children.length - 1) {
        spaced.add(SizedBox(
          width: layoutType == RowColType.row ? spacing : 0,
          height: layoutType == RowColType.column ? spacing : 0,
        ));
      }
    }
    return spaced;
  }
}
