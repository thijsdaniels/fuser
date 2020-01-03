import 'package:flutter/material.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';

class ToolBar extends StatelessWidget {
  final List<Tool> tools;
  final int selectedTool;
  final Function(int) onSelect;
  final EdgeInsets padding;

  ToolBar({
    Key key,
    @required this.tools,
    @required this.selectedTool,
    @required this.onSelect,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: tools.map((tool) {
            int index = tools.indexOf(tool);
            return IconButton(
              icon: Icon(tool.icon),
              disabledColor: Colors.grey.withOpacity(0.25),
              color: index == selectedTool ? Colors.deepPurple : Colors.grey,
              onPressed: () {
                onSelect(index);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Tool {
  final IconData icon;
  final Function(RectangularPosition) onPegTap;
  final Function(RectangularPosition) onPegLongPress;

  Tool({
    @required this.icon,
    @required this.onPegTap,
    this.onPegLongPress,
  });
}
