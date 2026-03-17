import 'package:flutter/material.dart';

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<String>? sizes;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.sizes,
  });
}
