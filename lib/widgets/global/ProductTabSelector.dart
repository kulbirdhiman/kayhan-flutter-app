import 'package:flutter/material.dart';

class ProductTabSelector extends StatelessWidget {
  final List<String> tabs;
  final Function(int) onTabChanged;

  const ProductTabSelector({
    super.key,
    required this.tabs,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DefaultTabController(
        length: tabs.length,
        child: TabBar(
          isScrollable: true,
          onTap: onTabChanged,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.purple,
          indicator: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(5),
          ),
          tabs: tabs
              .map((tab) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(tab),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
