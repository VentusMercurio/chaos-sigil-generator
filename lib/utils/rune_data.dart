// lib/utils/rune_data.dart
import 'package:flutter/material.dart'; // For Path
import 'dart:math';

// Forward declaration for the painter if you define it in another file
// class RunePainter extends CustomPainter { ... }

class Rune {
  final String name;
  final Path path; // Path to draw the rune
  final String meaning;
  // final Size inherentSize; // Optional: if runes have different base dimensions for scaling

  const Rune({
    required this.name,
    required this.path,
    required this.meaning,
    // required this.inherentSize,
  });
}

// --- Helper function to create paths ---
// You'll need to define the paths for each rune. This is the most time-consuming part.
// The coordinates should be relative to a bounding box, e.g., 0-100x0-100,
// so they can be easily scaled.

Path _createFehuPath() {
  Path path = Path();
  // Example: Define Fehu path (these are placeholder coordinates)
  // Assume a 100x100 box
  path.moveTo(50, 10); // Top of vertical stem
  path.lineTo(50, 90); // Bottom of vertical stem
  path.moveTo(50, 30); // Stem connection for upper branch
  path.lineTo(80, 10); // End of upper branch
  path.moveTo(50, 50); // Stem connection for lower branch
  path.lineTo(80, 30); // End of lower branch
  return path;
}

Path _createUruzPath() {
  Path path = Path();
  // Example: Define Uruz path
  path.moveTo(20, 10);
  path.lineTo(20, 90);
  path.lineTo(80, 10);
  path.lineTo(80, 90);
  return path;
}
// ... Define paths for ALL 24 runes ...
// This will take some effort to get the coordinates right for each rune.
// You can use an SVG editor to design them and then extract path data,
// or plot them out on graph paper first.

// Placeholder for other rune paths - YOU NEED TO DEFINE THESE
Path _placeholderPath() {
  Path path = Path();
  path.moveTo(10, 10);
  path.lineTo(90, 90);
  path.moveTo(90, 10);
  path.lineTo(10, 90);
  return path;
}

final List<Rune> elderFutharkRunes = [
  Rune(
      name: 'Fehu',
      path: _createFehuPath(),
      meaning: 'Cattle, Wealth, Prosperity, Energy, Foresight.'),
  Rune(
      name: 'Uruz',
      path: _createUruzPath(),
      meaning: 'Aurochs, Strength, Endurance, Health, Courage.'),
  Rune(
      name: 'Thurisaz',
      path: _placeholderPath(),
      meaning: 'Thorn, Giant, Protection, Destruction, Conflict.'),
  Rune(
      name: 'Ansuz',
      path: _placeholderPath(),
      meaning: 'God (Odin), Wisdom, Communication, Inspiration, Truth.'),
  Rune(
      name: 'Raidho',
      path: _placeholderPath(),
      meaning: 'Journey, Wheel, Travel, Rhythm, Right Action.'),
  Rune(
      name: 'Kenaz',
      path: _placeholderPath(),
      meaning: 'Torch, Knowledge, Creativity, Illumination, Clarity.'),
  Rune(
      name: 'Gebo',
      path: _placeholderPath(),
      meaning: 'Gift, Partnership, Generosity, Balance, Union.'),
  Rune(
      name: 'Wunjo',
      path: _placeholderPath(),
      meaning: 'Joy, Harmony, Success, Fulfillment, Well-being.'),
  Rune(
      name: 'Hagalaz',
      path: _placeholderPath(),
      meaning: 'Hail, Disruption, Sudden Change, Crisis, Transformation.'),
  Rune(
      name: 'Nauthiz',
      path: _placeholderPath(),
      meaning: 'Need, Constraint, Scarcity, Resistance, Self-Reliance.'),
  Rune(
      name: 'Isa',
      path: _placeholderPath(),
      meaning: 'Ice, Stillness, Stagnation, Challenge, Introspection.'),
  Rune(
      name: 'Jera',
      path: _placeholderPath(),
      meaning: 'Year, Harvest, Cycles, Reward, Fruition.'),
  Rune(
      name: 'Eihwaz',
      path: _placeholderPath(),
      meaning:
          'Yew Tree, Defense, Resilience, Transformation, The Inevitable.'),
  Rune(
      name: 'Perthro',
      path: _placeholderPath(),
      meaning: 'Lot Cup, Mystery, Fate, Chance, Secrets, Initiation.'),
  Rune(
      name: 'Algiz',
      path: _placeholderPath(),
      meaning: 'Elk, Protection, Higher Self, Divine Connection, Sanctuary.'),
  Rune(
      name: 'Sowilo',
      path: _placeholderPath(),
      meaning: 'Sun, Success, Vitality, Wholeness, Guidance.'),
  Rune(
      name: 'Tiwaz',
      path: _placeholderPath(),
      meaning: 'Tyr (God of War), Justice, Sacrifice, Honor, Victory.'),
  Rune(
      name: 'Berkano',
      path: _placeholderPath(),
      meaning: 'Birch Tree, New Beginnings, Growth, Nurturing, Rebirth.'),
  Rune(
      name: 'Ehwaz',
      path: _placeholderPath(),
      meaning: 'Horse, Movement, Partnership, Trust, Progress.'),
  Rune(
      name: 'Mannaz',
      path: _placeholderPath(),
      meaning: 'Mankind, Self, Humanity, Community, Awareness.'),
  Rune(
      name: 'Laguz',
      path: _placeholderPath(),
      meaning: 'Water, Flow, Emotion, Intuition, The Unconscious.'),
  Rune(
      name: 'Ingwaz',
      path: _placeholderPath(),
      meaning: 'Ing (God), Fertility, Internal Growth, Potential, Completion.'),
  Rune(
      name: 'Dagaz',
      path: _placeholderPath(),
      meaning: 'Day, Breakthrough, Awakening, Clarity, Hope.'),
  Rune(
      name: 'Othala',
      path: _placeholderPath(),
      meaning: 'Inheritance, Ancestry, Home, Legacy, Belonging.'),
];

Rune getRandomRune() {
  final random = Random();
  return elderFutharkRunes[random.nextInt(elderFutharkRunes.length)];
}
