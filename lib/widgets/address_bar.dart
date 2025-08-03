import 'package:flutter/material.dart';

class AddressBar extends StatelessWidget {
  const AddressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Virtual Office Address Melbourne – 440 Collins St',
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        textAlign: TextAlign.center,
      ),
    );
  }
}
