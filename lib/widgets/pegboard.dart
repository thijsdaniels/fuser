import 'package:flutter/material.dart';

abstract class Pegboard extends StatelessWidget {
  final bool fused;

  final Function onPegTap;
  final Function onPegLongPress;

  const Pegboard({
    Key key,
    @required this.fused,
    this.onPegTap,
    this.onPegLongPress,
  }) : super(key: key);
}
