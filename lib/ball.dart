import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double ballY;
  final double ballX;

  Ball({Key key, this.ballY, this.ballX}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
      ),
    );
  }
}
