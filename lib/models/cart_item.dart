import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  final IconData icon;
  final Color iconColor;
  final String? size;

  const CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.icon,
    required this.iconColor,
    this.size,
  });
}
