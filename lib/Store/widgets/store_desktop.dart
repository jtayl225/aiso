import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/Store/widgets/product_card.dart';
import 'package:aiso/Store/widgets/store_details.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreDesktop extends StatelessWidget {
  const StoreDesktop({super.key});

  @override
  Widget build(BuildContext context) {

    final storeViewModel = context.watch<StoreViewModel>();
    final products = storeViewModel.products;

    return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StoreDetails(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.color6,
                  AppColors.color5, 
                  AppColors.color4, 
                  AppColors.color3, 
                  AppColors.color2, 
                  AppColors.color1, 
                  // Colors.white,
                ],
              ),
            ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: products.map((product) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: ProductCard(product),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      );
  }
}