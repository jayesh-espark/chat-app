import 'package:flutter/material.dart';

import 'dart:convert';

class CategoryItem {
  final IconData icon;
  final String label;
  final int id;
  final Color color;

  CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'icon': icon.codePoint,
    'label': label,
    'color': color.value.toRadixString(16).padLeft(8, '0'),
    'id': id,
  };

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      icon: IconData(int.parse(json['icon']), fontFamily: 'MaterialIcons'),
      label: json['label'],
      color: Color(int.parse(json['color'], radix: 16)),
      id: json['id'],
    );
  }

  String toJsonString() => json.encode(toJson());

  factory CategoryItem.fromJsonString(String jsonString) {
    return CategoryItem.fromJson(json.decode(jsonString));
  }
}
