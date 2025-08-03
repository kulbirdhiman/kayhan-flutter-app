import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 172, 167, 167).withOpacity(0.1), // subtle shadow color
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(0, 3), // x, y offset
      ),
    ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://kayhanaudio.com.au/_next/image?url=https%3A%2F%2Fd198m4c88a0fux.cloudfront.net%2Fuploads%2F1751371299054_BA-BF-H.png&w=1080&q=75',
              height: 150,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Car Stereo with SatNav For",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "Ford FGX | 8.8\" Inch | V6",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "\$1595.00",
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text("(4.9)"),
                      ],
                    ),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
