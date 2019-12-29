import 'package:flutter/material.dart';
import 'package:fuser/models/palette.dart';
import 'package:fuser/models/swatch.dart';

class ColorPicker extends StatelessWidget {
  final Palette palette;
  final Function onSelect;

  ColorPicker({@required this.palette, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: DefaultTabController(
        length: palette.families.length,
        child: TabBarView(
          children: palette.families.map((family) {
            return Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.deepPurple,
                  child: Text(
                    family.name,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: family.swatches.map((code) {
                      Swatch swatch = palette.swatches[code];
                      return ListTile(
                        leading: AspectRatio(
                          aspectRatio: 1,
                          child: Container(color: swatch.color),
                        ),
                        title: Text(swatch.name),
                        subtitle: Text(swatch.code),
                        onTap: onSelect != null ? () {
                          onSelect(swatch);
                        } : null,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}