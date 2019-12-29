import 'package:flutter/material.dart';
import 'package:fuser/data/artkal-mini-c.dart';
import 'package:fuser/models/rectangular-pattern.dart';
import 'package:fuser/widgets/color-picker.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';
import 'package:fuser/widgets/tool-bar.dart';
import 'package:fuser/widgets/workspace.dart';

class Editor extends StatefulWidget {
  Editor({Key key, @required this.pattern}) : super(key: key);

  final RectangularPattern pattern;

  @override
  _EditorState createState() => _EditorState();
}

// @todo Lots of methods and state can be moved to SquarePegboard.
class _EditorState extends State<Editor> {
  List<List<Color>> _colors;
  Color _selectedColor = artkalMiniC.swatches['C02'].color;
  bool _fused = false;
  List<Tool> _tools;
  int _selectedToolIndex = 0;

  Tool get _selectedTool => _tools[_selectedToolIndex];

  void _setFused(bool fused) {
    setState(() {
      _fused = fused;
    });
  }

  Color _getColor(RectangularPosition position) {
    return _colors[position.row][position.column];
  }

  void _setColor(RectangularPosition position, Color color) {
    setState(() {
      _colors[position.row][position.column] = color;
    });
  }

  bool _onBoard(RectangularPosition position) {
    return position.row >= 0 &&
        position.row < widget.pattern.width &&
        position.column >= 0 &&
        position.column < widget.pattern.height;
  }

  void _fillArea(RectangularPosition position, Color color) {
    Color probe = _getColor(position);

    List<RectangularPosition> options = [position];
    List<RectangularPosition> visited = [];
    List<RectangularPosition> area = [];

    while (options.length > 0) {
      RectangularPosition option = options.removeAt(0);
      visited.add(option);

      if (!_onBoard(option)) continue;

      if (_getColor(option) == probe) {
        area.add(option);

        option.getNeighbors().forEach((adjacent) {
          if (!visited.contains(adjacent)) options.add(adjacent);
        });
      }
    }

    setState(() {
      area.forEach((position) {
        _colors[position.row][position.column] = color;
      });
    });
  }

  void _setSelectedColor(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _setSelectedToolIndex(int index) {
    setState(() {
      _selectedToolIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _colors = widget.pattern.colors;

    _tools = [
      Tool(
        icon: Icons.adjust,
        onPegTap: (position) {
          _setColor(position, _selectedColor);
        },
        onPegLongPress: (position) {
          _setColor(position, Colors.transparent);
        },
      ),
      Tool(
        icon: Icons.clear,
        onPegTap: (position) {
          _setColor(position, Colors.transparent);
        },
      ),
      Tool(
        icon: Icons.brush,
      ),
      Tool(
        icon: Icons.format_paint,
        onPegTap: (position) {
          _fillArea(position, _selectedColor);
        },
      ),
      Tool(
        icon: Icons.invert_colors,
      ),
      Tool(
        icon: Icons.colorize,
        onPegTap: (position) {
          _setSelectedColor(_getColor(position));
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style:
              Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          initialValue: widget.pattern.name,
          onChanged: (value) {
            widget.pattern.name = value;
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(_fused ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              _setFused(!_fused);
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              await widget.pattern.save();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Workspace(
        child: RectangularPegboard(
          width: widget.pattern.width,
          height: widget.pattern.height,
          colors: _colors,
          fused: _fused,
          onPegTap: _selectedTool.onPegTap,
          onPegLongPress: _selectedTool.onPegLongPress,
        ),
      ),
      bottomNavigationBar: ToolBar(
        tools: _tools,
        selectedTool: _selectedToolIndex,
        onSelect: _setSelectedToolIndex,
        padding: const EdgeInsets.only(right: 80),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedColor,
        child: Icon(
          Icons.palette,
          color: _selectedColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
        ),
        onPressed: _selectColor,
      ),
    );
  }

  Future<void> _selectColor() async {
    Color selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return ColorPicker(
          palette: artkalMiniC,
          onSelect: (swatch) {
            Navigator.pop(context, swatch.color);
          },
        );
      },
    );

    if (selectedColor != null) {
      _setSelectedColor(selectedColor);
    }
  }
}
