// ignore_for_file: unnecessary_import, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChartLabel extends StatelessWidget {
  const ChartLabel({this.name, this.color});

  final String? name;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
            height: 8,
            width: 15,
            margin: const EdgeInsets.only(right: 8),
            color: color),
        Text(
          name!,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
