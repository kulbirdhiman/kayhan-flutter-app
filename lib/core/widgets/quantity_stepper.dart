import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = compact ? 32.0 : 40.0;

    Widget button(IconData icon, VoidCallback? onTap, String label) => Semantics(
          button: true,
          label: label,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                size: compact ? 16 : 18,
                color: onTap == null ? scheme.onSurfaceVariant.withValues(alpha: 0.4) : scheme.onSurface,
              ),
            ),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, value > min ? () => onChanged(value - 1) : null, 'Decrease quantity'),
          SizedBox(
            width: compact ? 24 : 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          button(Icons.add_rounded, value < max ? () => onChanged(value + 1) : null, 'Increase quantity'),
        ],
      ),
    );
  }
}
