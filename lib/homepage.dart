import 'dart:async';

import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ball.dart';
import 'missile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
// player variables
  static double playerX = 0;

// missile variables
  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

//ball variables
  double ballX = 0.5;
  double ballY = 0;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jump is
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      //quadratic equation that models a bounce (upside down parabola)
      height = -5 * time * time + velocity * time;

      //if the ball reaches the ground,reset the jump
      if (height < 0) {
        time = 0;
      }
      //update the new ball position
      setState(() {
        ballY = heightToPosition(height);
      });

      // if the ball hits the left wall,then change direction to right
      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
        // if the ball hits the right wall,then change direction to le
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }
      // move the ball in the correct direction
      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }

      //check if ball hits the player
      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      //keep the time going!
      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You dead bro",
                style: TextStyle(
                  color: Colors.white,
                )),
            backgroundColor: Colors.grey[700],
          );
        });
  }

  void moveLeft() {
    setState(
      () {
        if (playerX - 0.1 < -1) {
          // do nothing
        } else {
          playerX -= 0.1;
        }
        // only make the X coordinate the same when it isn't in the middle of a shot
        if (!midShot) {
          missileX = playerX;
        }
      },
    );
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;
      }
      // only make the X coordinate the same when it isn't in the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(Duration(milliseconds: 20), (timer) {
        midShot = true;
        // missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });
        // stop missile when it reaches top of screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          //stop missile
          resetMissile();
          timer.cancel();
        }

        // check if missile has hit the ball
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          ballX = 5;
          resetMissile();
          timer.cancel();
        }
      });
    }
  }

  //converts height to a cordinate
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    midShot = false;
    missileHeight = 10;
  }

  bool playerDies() {
    // if the ball position and the player position are the same then player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    Ball(
                      ballX: ballX,
                      ballY: ballY,
                    ),
                    Missile(
                      missileX: missileX,
                      missileHeight: missileHeight,
                    ),
                    Player(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.play_arrow,
                    function: startGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    function: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    function: fireMissile,
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    function: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
