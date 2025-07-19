import 'package:aiso/Store/models/product_model.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCardSmall extends StatelessWidget {
  final Product product;

  const ProductCardSmall(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 300, minHeight: 200, maxHeight: 600),
      child: Stack(
        children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // side: const BorderSide(
            //   color: AppColors.color1,  // border color
            //   width: 2,           // border thickness
            // ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text(
                  product.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.black, // or any color you want
                      ),
                ),
      
                // price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (product.price > product.discountedPrice)
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black,
                            ),
                      ),
                    if (product.price > product.discountedPrice)
                      const SizedBox(width: 8),
        
                    Text(
                      '\$${product.discountedPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: (product.price > product.discountedPrice) ? Colors.red : Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.cadence,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      
        // Floating Save badge
        if (product.price > product.discountedPrice)
          Positioned(
            top: 24 + 4,
            right: 12 + 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Save ${product.pctDiscount*100}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      
        ]
      ),
    );
  }
}