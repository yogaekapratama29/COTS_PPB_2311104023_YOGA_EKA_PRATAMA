import 'package:flutter/material.dart';

class LayoutTokens {
  static const double gridBase = 8.0;
  static const double radius = 14.0;
  static BorderRadius borderRadius = BorderRadius.circular(radius);
  static BorderRadius borderRadiusTop = const BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );
  static BorderRadius borderRadiusBottom = const BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );
  static const double cardPaddingMin = 16.0;
  static const double cardPaddingMax = 20.0;
  static EdgeInsets cardPadding = const EdgeInsets.all(16.0);
  static EdgeInsets cardPaddingLarge = const EdgeInsets.all(20.0);
  static EdgeInsets cardPaddingVertical = const EdgeInsets.symmetric(
    vertical: 16.0,
    horizontal: 20.0,
  );
  static const double elevationCard = 6.0;
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x29000000), 
      offset: Offset(0, 6),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> floatingActionShadow = [
    BoxShadow(
      color: Color(0x3D000000),
      offset: Offset(0, 6),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
  static const double elevationFloating = 10.0;
  static List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x3D000000), 
      offset: Offset(0, 10),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const double buttonHeight = 48.0;
  static const double spacing1x = gridBase;
  static const double spacing2x = gridBase * 2;
  static const double spacing3x = gridBase * 3; 
  static const double spacing4x = gridBase * 4;
  static const double spacing5x = gridBase * 5;
  static const double spacing6x = gridBase * 6; 
  static EdgeInsets screenPadding = const EdgeInsets.all(16.0);
  static EdgeInsets screenPaddingHorizontal = const EdgeInsets.symmetric(horizontal: 16.0);
  static EdgeInsets screenPaddingVertical = const EdgeInsets.symmetric(vertical: 16.0);
  static const double listItemSpacing = 12.0;
  static const double listItemPadding = 16.0;
  static const double sectionSpacing = 24.0;
  static const double sectionSpacingLarge = 32.0;
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 16.0;
}