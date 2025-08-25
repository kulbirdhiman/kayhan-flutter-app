import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      "title": "Car Stereo with SatNav For\nFord FGX | 8.8'' Inch | Version 6",
      "price": 1795,
      "image": "https://via.placeholder.com/150",
      "quantity": 1,
    },
    {
      "title": "Car Stereo with SatNav For\nFord FGX | 8.8'' Inch | Version 6",
      "price": 1795,
      "image": "https://via.placeholder.com/150",
      "quantity": 1,
    },
    {
      "title": "Car Stereo with SatNav For\nFord FGX | 8.8'' Inch | Version 6",
      "price": 1795,
      "image": "https://via.placeholder.com/150",
      "quantity": 1,
    },
    {
      "title": "Car Stereo with SatNav For\nFord FGX | 8.8'' Inch | Version 6",
      "price": 1795,
      "image": "https://via.placeholder.com/150",
      "quantity": 1,
    },
  ];

  double get total {
    double sum = 0;
    for (var item in cartItems) {
      sum += item["price"] * item["quantity"];
    }
    return sum;
  }

  void incrementQty(int index) {
    setState(() {
      cartItems[index]["quantity"]++;
    });
  }

  void decrementQty(int index) {
    setState(() {
      if (cartItems[index]["quantity"] > 1) {
        cartItems[index]["quantity"]--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Delete button
                      InkWell(
                        onTap: () => removeItem(index),
                        child: Container(
                          height: 100,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                      ),

                      // Product Image + Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item["image"],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["title"],
                                      style: const TextStyle(fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${item["price"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Quantity Controls
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () => incrementQty(index),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                            Text("${item["quantity"]}"),
                            IconButton(
                              onPressed: () => decrementQty(index),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Subtotal + Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Sub Total:\n\$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to checkout
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
