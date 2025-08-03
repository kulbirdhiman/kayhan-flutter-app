import 'package:flutter/material.dart';
import 'package:kayhan_app/widgets/cards/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  centerTitle: true,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
    onPressed: () {
      // Handle back press
    },
  ),
  title: const Text(
    "My Cart",
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.black,
    ),
  ),
  actions: [
    Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: () {
            // Handle cart icon press
          },
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    ),
  ],
),

      body: ListView(
        // padding: const EdgeInsets.all(0),
        children: const [
          CartItemCard(
            imageUrl:
                'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
            title: 'Product Name',
            price: 49.99,
            quantity: 2,
          ),
          CartItemCard(
            imageUrl:
                'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
            title: 'Product Name',
            price: 49.99,
            quantity: 2,
          ),
          CartItemCard(
            imageUrl:
                'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
            title: 'Product Name',
            price: 49.99,
            quantity: 2,
          ),
          CartItemCard(
            imageUrl:
                'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
            title: 'Product Name',
            price: 49.99,
            quantity: 2,
          ),
          CartItemCard(
            imageUrl:
                'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
            title: 'Product Name',
            price: 49.99,
            quantity: 2,
          ),
          // CartItemCard(), // You can dynamically generate this list later
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total: \$249.95",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // handle checkout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ), // ❗ Sharp edges like a box
                ),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white, // ✅ Text color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
