import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductInclusion {
  final bool isIncluded;
  final String description;

  ProductInclusion({
    required this.isIncluded,
    required this.description
  });
}

class Product {
  final String id;
  final String title;
  final String description;
  final String cadence; // e.g., /month, /year, /report, etc
  final double price;
  final double pctDiscount;
  // final double reducedFromPrice;
  final List<ProductInclusion> productInclusions;
  final String callToAction; // e.g., But Now!, Subscribe!, etc
  final void Function(BuildContext context)? onPressed;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.cadence,
    required this.price,
    required this.pctDiscount,
    // required this.reducedFromPrice,
    required this.productInclusions,
    required this.callToAction,
    this.onPressed,
  });

  double get discountedPrice => price * (1 - pctDiscount);

}