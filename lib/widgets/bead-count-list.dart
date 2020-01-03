import 'package:flutter/material.dart';
import 'package:fuser/models/bead.dart';
import 'package:fuser/models/palette.dart';

class BeadCountList extends StatelessWidget {
  final Palette palette;
  final List<Color> colors;
  final EdgeInsets padding;

  BeadCountList({
    Key key,
    @required this.palette,
    @required this.colors,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<Bead, int> beadCounts = {};

    colors.where((color) => color != Colors.transparent).forEach((color) {
      Bead bead = palette.getBeadByColor(color);
      beadCounts[bead] =
          beadCounts.containsKey(bead) ? beadCounts[bead] + 1 : 1;
    });

    Map<Bead, int> sortedBeadCounts = Map.fromEntries(
        beadCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value)));

    return (ListView(
      padding: padding,
      children: sortedBeadCounts
          .map(
            (bead, count) {
              return MapEntry(
                bead,
                ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: Container(color: bead.color),
                  ),
                  title: Text(bead.name),
                  subtitle: Text(bead.code),
                  trailing: Chip(
                    label: Text(count.toString()),
                  ),
                ),
              );
            },
          )
          .values
          .toList(),
    ));
  }
}
