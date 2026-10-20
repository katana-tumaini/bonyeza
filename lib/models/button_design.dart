import 'package:flutter/material.dart';

class ButtonDesign {
  final String id;
  final String name;
  final Color color;
  final int cost;
  final bool isDefault;
  final String description;
  final BoxShape shape;
  final double borderWidth;
  final Color? borderColor;
  final bool isRainbow;

  const ButtonDesign({
    required this.id,
    required this.name,
    required this.color,
    required this.cost,
    this.isDefault = false,
    required this.description,
    this.shape = BoxShape.circle,
    this.borderWidth = 4.0,
    this.borderColor,
    this.isRainbow = false,
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
      isRainbow: true,
    ),
    // New designs with different shapes and styles
    ButtonDesign(
      id: 'square',
      name: 'Square Slate',
      color: Color(0xFF636E72),
      cost: 550,
      description: 'Perfectly square and solid',
      shape: BoxShape.rectangle,
    ),
    ButtonDesign(
      id: 'diamond',
      name: 'Diamond Cyan',
      color: Color(0xFF00CEC9),
      cost: 600,
      description: 'Sharp angles, bright future',
      shape: BoxShape.rectangle,
      borderWidth: 6.0,
      borderColor: Color(0xFF0984E3),
    ),
    ButtonDesign(
      id: 'rose',
      name: 'Rose Red',
      color: Color(0xFFE84393),
      cost: 650,
      description: 'Elegant and refined',
      borderWidth: 6.0,
      borderColor: Color(0xFFFD79A8),
    ),
    ButtonDesign(
      id: 'sky',
      name: 'Sky Blue',
      color: Color(0xFF74B9FF),
      cost: 700,
      description: 'Reach for the sky',
      borderWidth: 8.0,
      borderColor: Color(0xFF0984E3),
    ),
    ButtonDesign(
      id: 'forest',
      name: 'Forest Deep',
      color: Color(0xFF00B894),
      cost: 750,
      description: 'Deep green forest vibes',
      borderWidth: 6.0,
      borderColor: Color(0xFF006266),
    ),
    ButtonDesign(
      id: 'lavender',
      name: 'Lavender Dream',
      color: Color(0xFFA29BFE),
      cost: 800,
      description: 'Soft and dreamy purple',
      borderWidth: 5.0,
      borderColor: Color(0xFF6C5CE7),
    ),
    ButtonDesign(
      id: 'ruby',
      name: 'Ruby Red',
      color: Color(0xFFD63031),
      cost: 850,
      description: 'Precious red gemstone',
      borderWidth: 7.0,
      borderColor: Color(0xFF2D3436),
    ),
    ButtonDesign(
      id: 'shadow',
      name: 'Shadow Box',
      color: Color(0xFF636E72),
      cost: 900,
      description: 'Bold dark outline',
      shape: BoxShape.rectangle,
      borderWidth: 10.0,
      borderColor: Color(0xFF2D3436),
    ),
    ButtonDesign(
      id: 'neon',
      name: 'Neon Glow',
      color: Color(0xFF00FF87),
      cost: 950,
      description: 'Electric neon green',
      borderWidth: 8.0,
      borderColor: Color(0xFF00FF00),
    ),
    ButtonDesign(
      id: 'galaxy',
      name: 'Galaxy Star',
      color: Color(0xFF0984E3),
      cost: 1000,
      description: 'The ultimate cosmic design',
      shape: BoxShape.rectangle,
      borderWidth: 12.0,
      borderColor: Color(0xFF6C5CE7),
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
