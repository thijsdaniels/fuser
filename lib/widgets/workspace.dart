import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class Workspace extends StatefulWidget {
  final Widget Function(BuildContext, GlobalKey key) builder;
  final GlobalKey _parentKey = GlobalKey();
  final GlobalKey _childKey = GlobalKey();

  Workspace({
    Key key,
    @required this.builder,
  }) : super(key: key);

  @override
  _WorkspaceState createState() => _WorkspaceState();
}

class _WorkspaceState extends State<Workspace> {
  Offset _translation = Offset(0.0, 0.0);
  Offset _initialTranslation = Offset(0.0, 0.0);
  double _scale = 1.0;
  double _initialScale;

  void _setOffset(Offset offset) {
    setState(() {
      _translation = offset;
    });
  }

  void _setInitialOffset(Offset offset) {
    setState(() {
      _initialTranslation = offset;
    });
  }

  void _setScale(double scale) {
    setState(() {
      _scale = scale;
    });
  }

  void _setInitialScale(double scale) {
    setState(() {
      _initialScale = scale;
    });
  }

  void _reset() {
    setState(() {
      _translation = Offset(0.0, 0.0);
      _initialTranslation = Offset(0.0, 0.0);
      _scale = 1.0;
      _initialScale = null;
    });
  }

  void _zoomExtents() {
    final BuildContext parentContext = widget._parentKey.currentContext;
    final BuildContext childContext = widget._childKey.currentContext;

    if (parentContext == null || childContext == null) {
      return;
    }

    final RenderBox parentBox = parentContext.findRenderObject();
    final RenderBox childBox = childContext.findRenderObject();

    final Size parentSize = parentBox.size;
    final Size childSize = childBox.size;

    final double parentAspectRatio = parentSize.width / parentSize.height;
    final double childAspectRatio = childSize.width / childSize.height;

    final double scale = (childAspectRatio > parentAspectRatio)
        ? parentSize.width / childSize.width
        : parentSize.height / childSize.height;

    setState(() {
      _translation = Offset(0.0, 0.0);
      _initialTranslation = Offset(0.0, 0.0);
      _scale = scale;
      _initialScale = null;
    });
  }

  @override
  Widget build(BuildContext context) {
//    SchedulerBinding.instance
//        .addPostFrameCallback((_) => _zoomExtents());

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: () {
                    _setScale(_scale * 4/3);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: () {
                    _setScale(_scale * 3/4);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: _zoomExtents,
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen_exit),
                  onPressed: _reset,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('${(_scale * 100).toStringAsFixed(0)}%'),
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: Color(0xffeaeaea),
            child: GestureDetector(
              onScaleStart: (details) {
                _setInitialScale(_scale);
                _setInitialOffset(-_translation + details.focalPoint);
              },
              onScaleUpdate: (details) {
                _setScale(_initialScale * details.scale);
                _setOffset(-_initialTranslation + details.focalPoint);
              },
              onScaleEnd: (details) {
                _setInitialScale(null);
              },
              child: Container(
                // @important Without a color, the gestures don't work...
                color: Colors.transparent,
                padding: const EdgeInsets.all(16.0),
                child: Transform(
                  key: widget._parentKey,
                  transform: Matrix4.compose(
                    Vector3(_translation.dx, _translation.dy, 0.0),
                    Quaternion.identity(),
                    Vector3(_scale, _scale, 1.0),
                  ),
                  alignment: FractionalOffset.center,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: SizedOverflowBox(
                        size: Size(1, 1),
                        child: widget.builder(context, widget._childKey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
