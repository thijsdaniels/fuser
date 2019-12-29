import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuser/data/fuser-database.dart';
import 'package:sqflite/sqflite.dart';

import 'pattern.dart';

class RectangularPattern extends Pattern {
  final int width;
  final int height;
  List<List<Color>> colors;

  /// @todo Assert that the provided colors have the correct length.
  RectangularPattern({
    id,
    @required name,
    @required this.width,
    @required this.height,
    this.colors,
  }) : super(id: id, name: name) {
    if (colors == null) {
      colors = List.generate(
        height,
        (row) => List.generate(
          width,
          (column) => Colors.transparent,
        ),
      );
    }
  }

  @override
  RectangularPattern copyWith({String name}) {
    return RectangularPattern(
      name: name ?? this.name,
      width: width,
      height: height,
      colors: colors,
    );
  }

  ///////////////////
  ///// STORAGE /////
  ///////////////////

  @override
  Future<void> save() async {
    _exists() ? _update() : _insert();
  }

  @override
  Future<void> delete() async {
    if (!_exists()) return;
    _delete();
  }

  bool _exists() => id != null;

  static Future<List<RectangularPattern>> all() async {
    Database database = await FuserDatabase().database;

    List<Map<String, dynamic>> entries =
        await database.query('rectangularPatterns');

    return entries.map(fromMap).toList();
  }

  Future<void> _insert() async {
    Database database = await FuserDatabase().database;

    id = await database.insert('rectangularPatterns', toMap());
  }

  Future<void> _update() async {
    Database database = await FuserDatabase().database;

    await database.update('rectangularPatterns', toMap(),
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _delete() async {
    Database database = await FuserDatabase().database;

    await database
        .delete('rectangularPatterns', where: 'id = ?', whereArgs: [id]);
  }

  /////////////////////////
  ///// SERIALIZATION /////
  /////////////////////////

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
      'colors': _colorsToJson(colors),
    };
  }

  static RectangularPattern fromMap(Map<String, dynamic> map) {
    return RectangularPattern(
      id: map['id'],
      name: map['name'],
      width: map['width'],
      height: map['height'],
      colors: _colorsFromJson(map['colors']),
    );
  }

  static String _colorsToJson(List<List<Color>> colors) {
    return jsonEncode(colors.map((row) {
      return row.map(_colorToMap).toList();
    }).toList());
  }

  static List<List<Color>> _colorsFromJson(String json) {
    return jsonDecode(json).map<List<Color>>((row) {
      return row.map<Color>(_colorFromMap).toList() as List<Color>;
    }).toList() as List<List<Color>>;
  }

  static Map<String, int> _colorToMap(Color color) {
    return {
      'a': color.alpha,
      'r': color.red,
      'g': color.green,
      'b': color.blue,
    };
  }

  /// @todo Fix dynamic type.
  static Color _colorFromMap(dynamic color) {
    return Color.fromARGB(
      color['a'],
      color['r'],
      color['g'],
      color['b'],
    );
  }
}
