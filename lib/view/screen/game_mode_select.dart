import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hockey_game/view/game/game.dart';

class GameModeSelectPage extends StatefulWidget {
  @override
  _GameModeSelectPageState createState() => _GameModeSelectPageState();
}

class _GameModeSelectPageState extends State<GameModeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text("Random Match"),
          onPressed: () {
            final gameBox = MyBox2D();
            final game = MyGame(gameBox, context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => game.widget
            ));
          },
        ),
      ),
    );
  }
}
