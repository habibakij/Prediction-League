import 'package:flutter/material.dart';


class FFNavigationBarTheme {
  final Color? barBackgroundColor;
  final Color? selectedItemBackgroundColor;
  final Color? selectedItemIconColor;
  final Color? selectedItemLabelColor;
  final Color? selectedItemBorderColor;
  final Color? unselectedItemBackgroundColor;
  final Color? unselectedItemIconColor;
  final Color? unselectedItemLabelColor;


  final double barHeight;
  final double itemWidth;

  final bool showSelectedItemShadow;

  static const kDefaultItemWidth = 61.0;

  final kDefaultSelectedItemTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  final  kDefaultUnselectedTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  FFNavigationBarTheme({
    this.barBackgroundColor = Colors.white,
    this.selectedItemBackgroundColor = Colors.blueAccent,
    this.selectedItemIconColor = Colors.white,
    this.selectedItemLabelColor = Colors.black,
    this.selectedItemBorderColor = Colors.white,
    this.unselectedItemBackgroundColor = Colors.transparent,
    this.unselectedItemIconColor = Colors.grey,
    this.unselectedItemLabelColor = Colors.grey,
    this.itemWidth = kDefaultItemWidth,
    this.barHeight = 56.0,
    this.showSelectedItemShadow = true,
  });
}
