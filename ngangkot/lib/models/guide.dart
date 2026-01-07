import 'package:flutter/material.dart';

class Guide {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  Guide({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  Guide copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
  }) {
    return Guide(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  @override
  String toString() {
    return 'Guide(id: $id, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Guide && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
