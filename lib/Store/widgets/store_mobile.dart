import 'package:aiso/Store/view_models/store_view_model.dart';
import 'package:aiso/Store/widgets/inclusions_card.dart';
import 'package:aiso/Store/widgets/product_card.dart';
import 'package:aiso/Store/widgets/store_details.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StoreMobile extends StatelessWidget {
  const StoreMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final storeViewModel = context.watch<StoreViewModel>();
    final products = storeViewModel.products;
    final productInclusions = storeViewModel.productInclusions;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            StoreDetails(deviceType: DeviceScreenType.mobile),
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...products.map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ProductCard(product),
                      ),
                    ),

                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: InclusionsCard(inclusions: productInclusions),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}