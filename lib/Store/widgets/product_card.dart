import 'package:aiso/Store/models/product_model.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard(this.product, {super.key});

  // String _calculateDiscountPercent(Product product) {
  //   final discount = ((product.reducedFromPrice - product.price) / product.reducedFromPrice) * 100;
  //   return discount.toStringAsFixed(0);
  // }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 350, minHeight: 200, maxHeight: 600),
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
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [

                SizedBox(height: 8.0,),

                // title
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
        
                // // description
                // Text(
                //   product.description,
                //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //     color: Colors.black, // or any color you want
                //   ),
                // ),

                SizedBox(height: 8.0,),
        
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
        
                // const Spacer(),

                // const SizedBox(height: 8),
        
                // call-to-action button 
                Center(
                  child: ElevatedButton(
                    onPressed: () => product.onPressed?.call(context),
                    // onPressed: () {
                    //   // Add your action here
                    // },
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

        // highlight label
        if (product.highlightLabel != null && product.highlightLabel!.isNotEmpty)
          Positioned(
              top: 24 + 4,
              left: 12 + 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.color6,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  // 'Save ${_calculateDiscountPercent(product)}%',
                  product.highlightLabel ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
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
                // 'Save ${_calculateDiscountPercent(product)}%',
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