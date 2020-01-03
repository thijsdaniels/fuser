import 'package:flutter/material.dart';
import 'package:fuser/models/palette.dart';
import 'package:fuser/models/bead.dart';
import 'package:fuser/widgets/titled.dart';

class BeadPicker extends StatelessWidget {
  final Palette palette;
  final Function(Bead) onSelect;

  BeadPicker({@required this.palette, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DefaultTabController(
        length: palette.families.length,
        child: TabBarView(
          children: palette.families.map((family) {
            return Titled(
              title: family.name,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: family.beadCodes.map((code) {
                  Bead bead = palette.getBeadByCode(code);
                  return ListTile(
                    leading: AspectRatio(
                      aspectRatio: 1,
                      child: Container(color: bead.color),
                    ),
                    title: Text(bead.name),
                    subtitle: Text(bead.code),
                    onTap: onSelect != null
                        ? () {
                            onSelect(bead);
                          }
                        : null,
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
