import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class Workspace extends StatefulWidget {
  final Widget child;

  Workspace ({Key key, @required this.child}) : super(key: key);

  @override
  _WorkspaceState createState() => _WorkspaceState();
}

class _WorkspaceState extends State<Workspace> {
  Offset _translation = Offset(0, 0);
  Offset _initialTranslation = Offset(0, 0);
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
          color: Colors.transparent,
          child: Transform(
            transform: Matrix4.compose(
              Vector3(_translation.dx, _translation.dy, 0.0),
              Quaternion.identity(),
              Vector3(_scale, _scale, 1.0),
            ),
            alignment: FractionalOffset.center,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}