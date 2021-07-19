import 'package:flutter/material.dart';

class Missile extends StatelessWidget {
  const Missile({
    @required this.missileX,
    @required this.missileHeight,
  });

  final double missileX;

  final double missileHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(missileX, 1),
      child: Container(
        width: 2,
        height: missileHeight,
        color: Colors.grey,
      ),
    );
  }
}
