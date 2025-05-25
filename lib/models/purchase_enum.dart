enum ProductType {
  PURCHASE,
  SUBSCRIBE_MONTHLY,
  SUBSCRIBE_YEARLY,
}

extension ProductTypeExtension on ProductType {
  String get value {
    switch (this) {
      case ProductType.PURCHASE:
        return 'purchase';
      case ProductType.SUBSCRIBE_MONTHLY:
        return 'subscribe_monthly';
      case ProductType.SUBSCRIBE_YEARLY:
        return 'subscribe_yearly';
      default:
        return '';
    }
  }
}