import 'package:aiso/Store/models/product_model.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {super.key});

  String _calculateDiscountPercent(Product product) {
    final discount = ((product.reducedFromPrice - product.price) / product.reducedFromPrice) * 100;
    return discount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 350, minHeight: 200, maxHeight: 500),
      child: Stack(
        children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: AppColors.color1,  // border color
              width: 2,           // border thickness
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                    if (product.reducedFromPrice > product.price)
                      Text(
                        '\$${product.reducedFromPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.black,
                            ),
                      ),
                    if (product.reducedFromPrice > product.price)
                      const SizedBox(width: 8),
        
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.cadence,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.color1,
                            // fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
        
                // description
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black, // or any color you want
                  ),
                ),
        
                // dotted horizontal line
                const Divider(color: AppColors.color1),
        
                // list of inclusions - an inclusion is a row(icon, decription)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: product.productInclusions.map((inclusion) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(
                              inclusion.isIncluded ? Icons.check_circle : Icons.cancel,
                              color: inclusion.isIncluded ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                inclusion.description,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black, // or any color you want
                                  ),
                              )
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ),
      
                // const SizedBox(height: 16),
        
                // dotted horizontal line
                const Divider(color: AppColors.color1),
        
                const Spacer(),

                // const SizedBox(height: 16),
        
                // call-to-action button 
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your action here
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: AppColors.color1,
                    //   foregroundColor: AppColors.color3, // text & icon color
                    //   // side: const BorderSide(color: Colors.black), // optional: black border
                    //   elevation: 2, // optional: adjust for shadow
                    // ),
                    child: Text(
                      product.callToAction,
                      // style: Theme.of(context).textTheme.bodyLarge
                      ),
                  ),
                ),
        
                
        
                
              ],
            ),
          ),
        ),
      
        // Floating Save badge
        if (product.reducedFromPrice > product.price)
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
                'Save ${_calculateDiscountPercent(product)}%',
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