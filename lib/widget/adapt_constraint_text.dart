import 'dart:math';
import 'package:flutter/material.dart';

class AdaptConstraintText extends StatelessWidget {

  final String text;
  final TextStyle style;

  const AdaptConstraintText({Key? key, required this.text, required this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, l) {
          final layout = (TextPainter(
              text: TextSpan(text: text, style: style),
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr)
            ..layout(maxWidth: l.maxWidth));
          final maxLines = max(1, (l.biggest.height / layout.height).floor());
          return Text(
            text,
            style: style,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
          );
        }
    );
  }
}