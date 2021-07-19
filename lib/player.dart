import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    @required this.playerX,
  });

  final double playerX;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(playerX, 1.07),
      child: Image(
        image: AssetImage('images/bubble.png'),
      ),
    );
  }
}
