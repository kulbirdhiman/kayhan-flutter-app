import '../../../account/data/models/address.dart';
import '../../../cart/data/models/cart_item.dart';

enum OrderStatus {
  placed('Order placed'),
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderStatus(this.label);
  final String label;
}

enum PaymentMethod {
  card('Credit / debit card'),
  paypal('PayPal'),
  afterpay('Afterpay'),
  bankTransfer('Bank transfer');

  const PaymentMethod(this.label);
  final String label;
}

class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.address,
    required this.shippingMethodId,
    required this.shippingMethodName,
    required this.payment,
    required this.subtotal,
    required this.shipping,
    this.status = OrderStatus.placed,
    this.note,
  });

  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final Address address;
  final String shippingMethodId;
  final String shippingMethodName;
  final PaymentMethod payment;
  final double subtotal;
  final double shipping;
  final OrderStatus status;
  final String? note;

  double get total => subtotal + shipping;
  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        items: (json['items'] as List).map((e) => CartItem.fromJson(Map<String, dynamic>.from(e))).toList(),
        address: Address.fromJson(Map<String, dynamic>.from(json['address'])),
        shippingMethodId: json['shippingMethodId'] as String,
        shippingMethodName: json['shippingMethodName'] as String,
        payment: PaymentMethod.values.byName(json['payment'] as String),
        subtotal: (json['subtotal'] as num).toDouble(),
        shipping: (json['shipping'] as num).toDouble(),
        status: OrderStatus.values.byName(json['status'] as String),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'items': items.map((i) => i.toJson()).toList(),
        'address': address.toJson(),
        'shippingMethodId': shippingMethodId,
        'shippingMethodName': shippingMethodName,
        'payment': payment.name,
        'subtotal': subtotal,
        'shipping': shipping,
        'status': status.name,
        'note': note,
      };
}
