// subscription_plan.dart
class SubscriptionPlan {
  final int id;
  final String subscriptionName;
  final String price;
  final String type;

  SubscriptionPlan({
    required this.id,
    required this.subscriptionName,
    required this.price,
    required this.type,
  });

  // Create a SubscriptionPlan from JSON
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      subscriptionName: json['subscription_name'],
      price: json['price'],
      type: json['type'],
    );
  }

  // Convert a SubscriptionPlan to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_name': subscriptionName,
      'price': price,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'SubscriptionPlan(id: $id, subscriptionName: $subscriptionName, price: $price, type: $type)';
  }
}
