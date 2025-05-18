enum SearchTargetType {
  product,
  service,
  business,
  person,
}

extension SearchTargetTypeExtension on SearchTargetType {
  String get label {
    switch (this) {
      case SearchTargetType.product:
        return 'Product';
      case SearchTargetType.service:
        return 'Service';
      case SearchTargetType.business:
        return 'Business';
      case SearchTargetType.person:
        return 'Person';
    }
  }

  static SearchTargetType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'product':
        return SearchTargetType.product;
      case 'service':
        return SearchTargetType.service;
      case 'business':
        return SearchTargetType.business;
      case 'person':
        return SearchTargetType.person;
      default:
        throw ArgumentError('Invalid SearchTargetType: $value');
    }
  }
}
