import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuser/data/palettes.dart';
import 'package:fuser/models/rectangular-pattern.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';

import 'editor.dart';

class PatternDetails extends StatelessWidget {
  final RectangularPattern pattern;

  PatternDetails({
    Key key,
    @required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int beadCount = pattern.colors
        .expand((i) => i)
        .toList()
        .where((color) => color != Colors.transparent)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text(pattern.name),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black12,
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: 'pegboard-${pattern.id}',
                child: RectangularPegboard(
                  width: pattern.width,
                  height: pattern.height,
                  colors: pattern.colors,
                  fused: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text('Shape'),
                          Text('Rectangular'),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text('Dimensions'),
                          Text('${pattern.width} × ${pattern.height}')
                        ],
                      ),
                      TableRow(
                        children: [Text('Beads'), Text('$beadCount')],
                      ),
                      TableRow(
                        children: [
                          Text('Cost'),
                          Text('\$${(beadCount * 2.89 / 2000).toStringAsFixed(2)}'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return Editor(
                  pattern: pattern,
                  palette: Palettes.artkalMiniC, // @todo Get palette from pattern?
                );
              },
            ),
          );
        },
      ),
    );
  }
}
