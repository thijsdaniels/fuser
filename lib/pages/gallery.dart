import 'package:flutter/material.dart';
import 'package:fuser/data/palettes.dart';
import 'package:fuser/models/rectangular-pattern.dart';
import 'package:fuser/widgets/rectangular-pegboard.dart';

import 'editor.dart';

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  Future<List<RectangularPattern>> _futurePatterns = RectangularPattern.all();

  bool _fused = false;

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
          onPressed: _newPattern,
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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Editor(
            pattern: pattern,
            palette: Palettes.artkalMiniC, // @todo Get palette from pattern?
          ),
        ),
      ),
      leading: RectangularPegboard(
        width: pattern.width,
        height: pattern.height,
        fused: _fused,
        colors: pattern.colors,
      ),
      title: Text(pattern.name),
      subtitle: Text('${pattern.width} × ${pattern.height}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () async {
              await pattern.copyWith(name: '${pattern.name} (Copy)').save();
              _refresh();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await pattern.delete();
              _refresh();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _newPattern() async {
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
        MaterialPageRoute(
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
