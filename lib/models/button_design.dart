import 'package:flutter/material.dart';

class ButtonDesign {
  final String id;
  final String name;
  final Color color;
  final int cost;
  final bool isDefault;
  final String description;

  const ButtonDesign({
    required this.id,
    required this.name,
    required this.color,
    required this.cost,
    this.isDefault = false,
    required this.description,
  });

  // Predefined button designs
  static const List<ButtonDesign> designs = [
    ButtonDesign(
      id: 'default',
      name: 'Classic Teal',
      color: Color(0xFF4ECDC4),
      cost: 0,
      isDefault: true,
      description: 'The original button design',
    ),
    ButtonDesign(
      id: 'fire',
      name: 'Fire Red',
      color: Color(0xFFFF6B6B),
      cost: 100,
      description: 'Burn through the game with style',
    ),
    ButtonDesign(
      id: 'ocean',
      name: 'Ocean Blue',
      color: Color(0xFF4D96FF),
      cost: 150,
      description: 'Cool blue like the deep sea',
    ),
    ButtonDesign(
      id: 'golden',
      name: 'Golden Glory',
      color: Color(0xFFFFD93D),
      cost: 200,
      description: 'Shine bright like a champion',
    ),
    ButtonDesign(
      id: 'emerald',
      name: 'Emerald Green',
      color: Color(0xFF6BCB77),
      cost: 250,
      description: 'Fresh and vibrant green',
    ),
    ButtonDesign(
      id: 'royal',
      name: 'Royal Purple',
      color: Color(0xFF9D4EDD),
      cost: 300,
      description: 'Rule the game in purple',
    ),
    ButtonDesign(
      id: 'sunset',
      name: 'Sunset Orange',
      color: Color(0xFFFF9F1C),
      cost: 350,
      description: 'Warm sunset vibes',
    ),
    ButtonDesign(
      id: 'midnight',
      name: 'Midnight',
      color: Color(0xFF2D3436),
      cost: 400,
      description: 'Dark and mysterious',
    ),
    ButtonDesign(
      id: 'candy',
      name: 'Candy Pink',
      color: Color(0xFFFF758F),
      cost: 450,
      description: 'Sweet and playful',
    ),
    ButtonDesign(
      id: 'rainbow',
      name: 'Rainbow',
      color: Color(0xFF00D2D3),
      cost: 500,
      description: 'A splash of colors',
    ),
  ];

  // Get button design by ID
  static ButtonDesign? getById(String id) {
    try {
      return designs.firstWhere((design) => design.id == id);
    } catch (e) {
      return null;
    }
  }
}
