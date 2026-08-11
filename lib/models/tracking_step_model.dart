import 'package:flutter/material.dart';

enum TrackingStepStatus { completed, live, pending }

class TrackingStepModel {
  final String title;
  final String? description;
  final IconData icon;
  final String timeLabel;
  final TrackingStepStatus status;

  const TrackingStepModel({
    required this.title,
    this.description,
    required this.icon,
    required this.timeLabel,
    required this.status,
  });
}