import 'package:flutter/material.dart';

abstract class Pattern<ColorList> {
  int id;
  String name;
  ColorList colors;

  Pattern({
    this.id,
    @required this.name,
    this.colors
  }) {
    if (colors == null) {
      colors = initializeColors();
    }
  }

  @protected
  ColorList initializeColors();

  ColorList copyColors();

  Pattern copyWith({String name});

  Future<void> save();

  Future<void> delete();
}