import 'package:flutter/material.dart';
import 'package:fuser/models/palette.dart';
import 'package:fuser/models/rectangular-pattern.dart';
import 'package:fuser/widgets/bead-count-list.dart';
import 'package:fuser/widgets/bead-picker.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';
import 'package:fuser/widgets/titled.dart';
import 'package:fuser/widgets/tool-bar.dart';
import 'package:fuser/widgets/workspace.dart';

class Editor extends StatefulWidget {
  final RectangularPattern pattern;
  final Palette palette;

  Editor({
    Key key,
    @required this.pattern,
    @required this.palette,
  }) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

// @todo Lots of methods and state can be moved to SquarePegboard.
class _EditorState extends State<Editor> {
  String _name;
  List<List<Color>> _colors;
  Color _selectedColor;
  bool _fused = false;
  List<Tool> _tools;
  int _selectedToolIndex = 0;

  Tool get _selectedTool => _tools[_selectedToolIndex];

  void _setName(String name) {
    setState(() {
      _name = name;
    });
  }

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
        position.row < widget.pattern.height &&
        position.column >= 0 &&
        position.column < widget.pattern.width;
  }

  void _fillArea(RectangularPosition position, Color color) {
    Color probe = _getColor(position);

    List<RectangularPosition> options = [position];
    List<RectangularPosition> visited = [];
    List<RectangularPosition> area = [];

    while (options.length > 0) {
      RectangularPosition option = options.removeAt(0);

      if (visited.contains(option)) continue;
      visited.add(option);

      if (!_onBoard(option)) continue;

      if (_getColor(option) == probe) {
        area.add(option);
        option.getNeighbors().forEach(options.add);
      }
    }

    setState(() {
      area.forEach((position) {
        _colors[position.row][position.column] = color;
      });
    });
  }

  void _replaceColor(RectangularPosition position, Color color) {
    Color probe = _getColor(position);

    setState(() {
      _colors = _colors.map((row) {
        return row.map((option) {
          return option == probe ? color : option;
        }).toList();
      }).toList();
    });
  }

  _shiftColors(Offset distance) {
    for (int i = 0; i < distance.dy.abs(); i++) {
      if (distance.dy < 0) {
        _colors.insert(_colors.length, _colors.removeAt(0));
      } else if (distance.dy > 0) {
        _colors.insert(0, _colors.removeLast());
      }
    }

    for (int i = 0; i < distance.dx.abs(); i++) {
      if (distance.dx < 0) {
        for (List<Color> row in _colors) {
          row.insert(row.length, row.removeAt(0));
        }
      } else if (distance.dx > 0) {
        for (List<Color> row in _colors) {
          row.insert(0, row.removeLast());
        }
      }
    }

    setState(() {
      _colors = _colors;
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

    _name = '${widget.pattern.name}';
    _colors = widget.pattern.copyColors();
    _selectedColor = widget.palette.defaultBead.color;

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
        icon: Icons.not_interested,
        onPegTap: (position) {
          _setColor(position, Colors.transparent);
        },
      ),
      Tool(
        icon: Icons.format_paint,
        onPegTap: (position) {
          _fillArea(position, _selectedColor);
        },
      ),
      Tool(
          icon: Icons.invert_colors,
          onPegTap: (position) {
            _replaceColor(position, _selectedColor);
          }),
      Tool(
        icon: Icons.open_with,
        onPegTap: (position) {
          _shiftColors(Offset(1, 0));
        },
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
          Theme
              .of(context)
              .textTheme
              .title
              .copyWith(color: Colors.white),
          initialValue: _name,
          onChanged: (value) {
            _setName(value);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: null,
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: _showInfo,
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
              widget.pattern.name = _name;
              widget.pattern.colors = _colors;
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
        onPressed: () {
          _selectColor(widget.palette);
        },
      ),
    );
  }

  Future<void> _showInfo() async {
    await showDialog<Color>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Titled(
            title: 'Bead Count',
            child: BeadCountList(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              palette: widget.palette,
              colors: _colors.expand((i) => i).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectColor(Palette palette) async {
    Color selectedColor = await showDialog<Color>(
      context: context,
      builder: (context) {
        return BeadPicker(
          palette: palette,
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
