import 'package:flutter/material.dart';

class TodoThemeExtension extends ThemeExtension<TodoThemeExtension> {
  final Color categoryBackgroundColor;
  final Color categoryTextColor;

  TodoThemeExtension({
    required this.categoryBackgroundColor,
    required this.categoryTextColor,
  });

  @override
  TodoThemeExtension copyWith({
    Color? categoryBackgroundColor,
    Color? categoryTextColor,
  }) {
    return TodoThemeExtension(
      categoryBackgroundColor:
          categoryBackgroundColor ?? this.categoryBackgroundColor,
      categoryTextColor: categoryTextColor ?? this.categoryTextColor,
    );
  }

  @override
  TodoThemeExtension lerp(ThemeExtension<TodoThemeExtension>? other, double t) {
    if (other is! TodoThemeExtension) {
      return this;
    }
    return TodoThemeExtension(
      categoryBackgroundColor: Color.lerp(
          categoryBackgroundColor, other.categoryBackgroundColor, t)!,
      categoryTextColor:
          Color.lerp(categoryTextColor, other.categoryTextColor, t)!,
    );
  }

  static final light = TodoThemeExtension(
    categoryBackgroundColor: Colors.white,
    categoryTextColor: Colors.black87,
  );

  static final dark = TodoThemeExtension(
    categoryBackgroundColor: Colors.grey[800]!,
    categoryTextColor: Colors.white,
  );
}

Color getCategoryColor(BuildContext context, String hexColor) {
  final color = Color(int.parse(hexColor.replaceAll('#', '0xFF')));
  if (Theme.of(context).brightness == Brightness.dark) {
    return HSLColor.fromColor(color)
        .withLightness(HSLColor.fromColor(color).lightness * 0.8)
        .toColor();
  }
  return color;
}
