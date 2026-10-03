/// Store-level business settings.
///
/// PLACEHOLDER VALUES — replace with Kayhan's real shipping rates and
/// thresholds before release. They are kept in one place so the cart and
/// checkout screens never hard-code numbers.
class StoreConfig {
  StoreConfig._();

  static const currencySymbol = r'$';
  static const currencyLocale = 'en_AU';
  static const country = 'Australia';

  /// Prices in Australia include 10% GST, so GST = total / 11.
  static const gstDivisor = 11;

  static const freeShippingThreshold = 99.0;

  static const shippingMethods = <ShippingMethod>[
    ShippingMethod(
      id: 'standard',
      name: 'Standard delivery',
      eta: '3–7 business days',
      price: 14.95,
      freeOverThreshold: true,
    ),
    ShippingMethod(
      id: 'express',
      name: 'Express delivery',
      eta: '1–3 business days',
      price: 29.95,
    ),
    ShippingMethod(
      id: 'pickup',
      name: 'Click & collect',
      eta: 'Ready in 1 business day',
      price: 0,
    ),
  ];

  static const australianStates = [
    'ACT', 'NSW', 'NT', 'QLD', 'SA', 'TAS', 'VIC', 'WA', //
  ];
}

class ShippingMethod {
  const ShippingMethod({
    required this.id,
    required this.name,
    required this.eta,
    required this.price,
    this.freeOverThreshold = false,
  });

  final String id;
  final String name;
  final String eta;
  final double price;
  final bool freeOverThreshold;

  double costFor(double subtotal) {
    if (freeOverThreshold && subtotal >= StoreConfig.freeShippingThreshold) {
      return 0;
    }
    return price;
  }

  static ShippingMethod byId(String id) => StoreConfig.shippingMethods
      .firstWhere((m) => m.id == id, orElse: () => StoreConfig.shippingMethods.first);
}
