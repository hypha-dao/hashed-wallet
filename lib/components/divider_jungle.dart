import 'package:flutter/material.dart';

class DividerJungle extends StatelessWidget {
  final double thickness;
  final double height;

  const DividerJungle({super.key, this.thickness = 3, this.height = 1});

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: thickness, height: height);
  }
}
