import 'package:flutter/material.dart';

abstract class Pattern {
  int id;
  String name;

  Pattern({
    this.id,
    @required this.name,
  });

  Pattern copyWith({String name});

  Future<void> save();

  Future<void> delete();
}