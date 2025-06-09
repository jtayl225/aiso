import 'package:aiso/Store/models/product_model.dart';
import 'package:aiso/Store/widgets/product_card.dart';
import 'package:aiso/constants/app_colors.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Product> products = [
    Product(
      id: '1',
      title: 'Individual Report',
      description: 'Get started with a single one-off report.',
      cadence: '/ month (AUD)',
      price: 14.99,
      reducedFromPrice: 19.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$14.99 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Only 1 report'),
        ProductInclusion(isIncluded: false, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: false, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: false, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Buy Now',
    ),
    Product(
      id: '2',
      title: 'Monthly Plan',
      description: 'All features for growing teams.',
      cadence: '/ month (AUD)',
      price: 9.99,
      reducedFromPrice: 14.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$9.99 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: true, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Subscribe',
    ),
    Product(
      id: '3',
      title: 'Yearly Plan',
      description: 'Custom solutions for businesses.',
      cadence: '/ year (AUD)',
      price: 99.99,
      reducedFromPrice: 179.99,
      productInclusions: [
        ProductInclusion(isIncluded: true, description: '\$8.30 / report'),
        ProductInclusion(isIncluded: true, description: 'ChatGPT (OpenAI)'),
        ProductInclusion(isIncluded: true, description: 'Gemini (Google)'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 reports / month'),
        ProductInclusion(isIncluded: true, description: 'Up to 10 prompts / report'),
        ProductInclusion(isIncluded: true, description: 'Automated monthly report updates'),
      ],
      callToAction: 'Subscribe',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildIndicatorDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(products.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? AppColors.color6 : Colors.grey,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return ProductCard(products[index]);
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildIndicatorDots(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}