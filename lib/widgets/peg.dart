import 'package:flutter/material.dart';

const MILLIMETER = 6.299;

/// @todo Parts of this class, such as the DIAMETER constant, need to be moved
/// to an `ArtkalMiniBead extends Bead` model.
class Peg extends StatelessWidget {
  static const DIAMETER = 2.6 * MILLIMETER;

  final Color color;
  final Color beadColor;
  final bool fused;

  final Function onTap;
  final Function onLongPress;

  Peg({
    this.color,
    @required this.beadColor,
    this.fused,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        width: Peg.DIAMETER,
        height: Peg.DIAMETER,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: !fused
              ? BorderRadius.circular(Peg.DIAMETER / 2)
              : BorderRadius.circular(Peg.DIAMETER / 6),
          color: beadColor,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOut,
            width: !fused ? Peg.DIAMETER / 4 : 0,
            height: !fused ? Peg.DIAMETER / 4 : 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
