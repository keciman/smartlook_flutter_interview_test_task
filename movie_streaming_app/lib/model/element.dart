import 'package:flutter/cupertino.dart';

class SmartlookElement {
  final double top;
  final double left;
  final double width;
  final double height;
  final Color color;

  SmartlookElement({this.top, this.left, this.width, this.height, this.color});

  @override
  String toString() =>
      "{top: $top, left: $left, width: $width, height: $height, color: ${color?.toFormattedString()}}";
}

extension on Color {
  String toFormattedString() => "#${this.value.toRadixString(16)}";
}
