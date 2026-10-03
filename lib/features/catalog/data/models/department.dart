import 'package:flutter/material.dart';

/// Top-level shop section (SatNav Stereo, Audio Equipment, Accessories…).
class Department {
  const Department({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.order = 0,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;
  final int order;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: (json['id'] as num).toInt(),
        name: (json['name'] ?? '').toString().trim(),
        slug: (json['slug'] ?? '').toString(),
        description: json['description']?.toString(),
        order: int.tryParse('${json['order_index']}') ?? 0,
      );

  /// Keyword used against the product search endpoint.
  String get searchTerm => switch (slug) {
        'satnav-stereo' => 'SatNav',
        'linux-stereo' => 'Linux',
        'carplay-module' => 'CarPlay',
        'digital-instrument-cluster' => 'Digital Cluster',
        'frames-fascias' => 'Fascia',
        'universal-2-din' => 'Universal',
        'car-batteries' => 'Battery',
        'audio-equipments' => 'Audio',
        'accessories' => 'Accessories',
        'tyres' => 'Tyre',
        'deals' => 'Combo',
        _ => name,
      };

  IconData get icon => switch (slug) {
        'satnav-stereo' => Icons.navigation_rounded,
        'linux-stereo' => Icons.tablet_android_rounded,
        'carplay-module' => Icons.phone_iphone_rounded,
        'steering-wheel' => Icons.trip_origin_rounded,
        'audio-equipments' => Icons.speaker_rounded,
        'car-batteries' => Icons.battery_charging_full_rounded,
        'tyres' => Icons.tire_repair_rounded,
        'deals' => Icons.local_offer_rounded,
        'frames-fascias' => Icons.crop_square_rounded,
        'accessories' => Icons.cable_rounded,
        'universal-2-din' => Icons.dashboard_rounded,
        'digital-instrument-cluster' => Icons.speed_rounded,
        _ => Icons.category_rounded,
      };
}
