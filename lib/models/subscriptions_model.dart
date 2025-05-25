class Subscription {
  final String id;
  final String userId;

  final String stripeCustomerId;
  final String stripeSubscriptionId;
  final String? stripePriceId;
  final String? stripeProductId;
  final int? stripeQuantity;

  final String stripeStatus;

  final DateTime stripeCreated;
  final DateTime stripeStartDate;
  final DateTime? stripeEndedAt;
  final DateTime? stripeCancelAt;
  final DateTime? stripeCanceledAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  Subscription({
    required this.id,
    required this.userId,
    required this.stripeCustomerId,
    required this.stripeSubscriptionId,
    this.stripePriceId,
    this.stripeProductId,
    this.stripeQuantity,
    required this.stripeStatus,
    required this.stripeCreated,
    required this.stripeStartDate,
    this.stripeEndedAt,
    this.stripeCancelAt,
    this.stripeCanceledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      stripeCustomerId: json['stripe_customer_id'],
      stripeSubscriptionId: json['stripe_subscription_id'],
      stripePriceId: json['stripe_price_id'],
      stripeProductId: json['stripe_product_id'],
      stripeQuantity: json['stripe_quantity'],
      stripeStatus: json['stripe_status'],
      stripeCreated: DateTime.parse(json['stripe_created']),
      stripeStartDate: DateTime.parse(json['stripe_start_date']),
      stripeEndedAt: json['stripe_ended_at'] != null ? DateTime.parse(json['stripe_ended_at']) : null,
      stripeCancelAt: json['stripe_cancel_at'] != null ? DateTime.parse(json['stripe_cancel_at']) : null,
      stripeCanceledAt: json['stripe_canceled_at'] != null ? DateTime.parse(json['stripe_canceled_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'stripe_customer_id': stripeCustomerId,
      'stripe_subscription_id': stripeSubscriptionId,
      'stripe_price_id': stripePriceId,
      'stripe_product_id': stripeProductId,
      'stripe_quantity': stripeQuantity,
      'stripe_status': stripeStatus,
      'stripe_created': stripeCreated.toIso8601String(),
      'stripe_start_date': stripeStartDate.toIso8601String(),
      'stripe_ended_at': stripeEndedAt?.toIso8601String(),
      'stripe_cancel_at': stripeCancelAt?.toIso8601String(),
      'stripe_canceled_at': stripeCanceledAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
