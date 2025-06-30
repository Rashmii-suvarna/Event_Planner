import 'package:flutter/material.dart';

class AppStyles {
  static const headingText = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      )
    ],
  );

  static const inputText = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const labelStyle = TextStyle(
    fontSize: 14,
    color: Colors.deepPurple,
  );

  static final inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    filled: true,
    fillColor: Colors.white,
    labelStyle: labelStyle,
  );
}
