import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuser/data/palettes.dart';
import 'package:fuser/models/rectangular-pattern.dart';
import 'package:fuser/pages/pattern-details.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';

import 'editor.dart';

enum PatternAction {
  edit,
  duplicate,
  delete,
}

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future<List<RectangularPattern>> _futurePatterns = RectangularPattern.all();

  bool _fused = true;

  void _setFused(bool fused) {
    setState(() {
      _fused = fused;
    });
  }

  void _refresh() {
    setState(() {
      _futurePatterns = RectangularPattern.all();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gallery'),
          actions: [
            IconButton(
              icon: Icon(_fused ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                _setFused(!_fused);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'RECTANGLE'),
              Tab(text: 'HEXAGON'),
              Tab(text: 'CIRCLE'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<RectangularPattern>>(
              future: _futurePatterns,
              builder: (context, snapshot) {
                return RefreshIndicator(
                  onRefresh: () async => _refresh(),
                  child: _buildPatternList(context, snapshot.data),
                );
              },
            ),
            Container(),
            Container(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _create,
        ),
      ),
    );
  }

  Widget _buildPatternList(
    BuildContext context,
    List<RectangularPattern> patterns,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8.0, bottom: 88.0),
      itemCount: patterns?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildPatternItem(context, patterns[index]);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildPatternItem(BuildContext context, RectangularPattern pattern) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) {
              return PatternDetails(
                pattern: pattern,
              );
            },
          ),
        );
      },
      leading: Hero(
        tag: 'pegboard-${pattern.id}',
        child: RectangularPegboard(
          width: pattern.width,
          height: pattern.height,
          fused: _fused,
          colors: pattern.colors,
        ),
      ),
      title: Text(pattern.name),
      subtitle: Text('${pattern.width} × ${pattern.height}'),
      trailing: PopupMenuButton<PatternAction>(
        onSelected: (PatternAction result) async {
          switch(result) {
            case PatternAction.edit:
              return _edit(context, pattern);
            case PatternAction.duplicate:
              return _duplicate(pattern);
            case PatternAction.delete:
              return _delete(pattern);
          }
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem<PatternAction>(
            value: PatternAction.edit,
            child: Text('Edit'),
          ),
          const PopupMenuItem<PatternAction>(
            value: PatternAction.duplicate,
            child: Text('Duplicate'),
          ),
          const PopupMenuItem<PatternAction>(
            value: PatternAction.delete,
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context, RectangularPattern pattern) {
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
  }

  Future<void> _duplicate(RectangularPattern pattern) async {
    await pattern.copyWith(name: '${pattern.name} (Copy)').save();
    _refresh();
  }

  Future<void> _delete(RectangularPattern pattern) async {
    await pattern.delete();
    _refresh();
  }

  Future<void> _create() async {
    int size = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [4, 8, 16, 24, 32, 48, 64].map((size) {
              return RaisedButton(
                child: Text('$size'),
                onPressed: () {
                  Navigator.pop(context, size);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (size != null) {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => Editor(
            pattern: RectangularPattern(
              name: 'Untitled',
              width: size,
              height: size,
            ),
            palette: Palettes.artkalMiniC,
          ),
        ),
      );
    }
  }
}
