import 'package:flutter/material.dart';

class Titled extends StatelessWidget {
  final String title;
  final Widget child;

  Titled({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.deepPurple,
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
