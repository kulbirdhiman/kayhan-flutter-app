import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayhan_app/core/theme/app_theme.dart';

void main() {
  test('component text styles carry explicit font sizes', () {
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      expect(theme.appBarTheme.titleTextStyle?.fontSize, 22);
      expect(theme.textTheme.titleMedium?.fontWeight, FontWeight.w700);
    }
  });
}
