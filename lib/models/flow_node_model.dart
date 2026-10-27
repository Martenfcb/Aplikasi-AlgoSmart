import 'package:flutter/material.dart';

enum FlowNodeType {
  start,
  process,
  input,
  output,
  decision,
  end,
}

class FlowNodeModel {
  final String title;

  final String description;

  final FlowNodeType type;

  final bool active;

  final Color color;

  const FlowNodeModel({
    required this.title,
    required this.description,
    required this.type,
    required this.color,
    this.active = false,
  });

  FlowNodeModel copyWith({
    String? title,
    String? description,
    FlowNodeType? type,
    Color? color,
    bool? active,
  }) {
    return FlowNodeModel(
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      color: color ?? this.color,
      active: active ?? this.active,
    );
  }
}