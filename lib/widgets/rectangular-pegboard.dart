import 'package:flutter/material.dart';

import 'peg.dart';
import 'pegboard.dart';

class RectangularPegboard extends Pegboard {
  final int gridSpacing;
  final int width;
  final int height;
  final List<List<Color>> colors;

  final Function(RectangularPosition) onPegTap;
  final Function(RectangularPosition) onPegLongPress;

  const RectangularPegboard({
    this.gridSpacing = 15,
    @required this.width,
    @required this.height,
    @required this.colors,
    @required fused,
    this.onPegTap,
    this.onPegLongPress,
  }) : super(
          fused: fused,
          onPegTap: onPegTap,
          onPegLongPress: onPegLongPress,
        );

  bool _isOnGridLine(RectangularPosition position) {
    return position.row % gridSpacing == 0 ||
        position.column % gridSpacing == 0;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        children: List.generate(height, (row) {
          return Row(
            children: List.generate(width, (column) {
              RectangularPosition position = RectangularPosition(row, column);
              return Peg(
                color: _isOnGridLine(position) ? Colors.black26 : Colors.black12,
                beadColor: colors[row][column],
                fused: fused,
                onTap: onPegTap != null ? () => onPegTap(position) : null,
                onLongPress: onPegLongPress != null
                    ? () => onPegLongPress(position)
                    : null,
              );
            }),
          );
        }),
      ),
    );
  }
}

class RectangularPosition {
  final int row;
  final int column;

  const RectangularPosition(this.row, this.column);

  List<RectangularPosition> getNeighbors() {
    return [
      RectangularPosition(row + 1, column),
      RectangularPosition(row - 1, column),
      RectangularPosition(row, column + 1),
      RectangularPosition(row, column - 1),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RectangularPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          column == other.column;

  @override
  int get hashCode => row.hashCode + column.hashCode;
}
