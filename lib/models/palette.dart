import 'package:flutter/material.dart';

import 'bead.dart';
import 'family.dart';

class Palette {
  final String name;
  final List<Bead> beads;
  final String defaultBeadCode;
  final List<Family> families;

  Map<String, Bead> _beadsByCode;
  Map<Color, Bead> _beadsByColor;

  Palette({
    @required this.name,
    @required this.beads,
    @required this.defaultBeadCode,
    @required this.families,
  }) {
    _beadsByCode = Map.fromIterable(
      beads,
      key: (bead) => bead.code,
      value: (bead) => bead,
    );

    _beadsByColor = Map.fromIterable(
      beads,
      key: (bead) => bead.color,
      value: (bead) => bead,
    );
  }

  Bead get defaultBead => getBeadByCode(defaultBeadCode);

  Bead getBeadByCode(String code) {
    return _beadsByCode[code];
  }

  Bead getBeadByColor(Color color) {
    return _beadsByColor[color];
  }
}
