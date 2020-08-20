import 'package:flutter/material.dart';
import 'package:flutter_hockey_game/control/AuthenController.dart';
import 'package:flutter_hockey_game/model/authen.dart';

class AuthenPage extends StatelessWidget {
  AuthenRepository _authenRepository;
  AuthenController _authenController;

  AuthenPage() {
    _authenRepository = new FirebaseAuthenRepository();
    _authenController = new AuthenControllerImp(_authenRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (sContext) {
          _authenRepository.authenstatus.listen((event) async {
            print("MEOW MEOW LOGGED IN");
            await showDialog(
                context: sContext,
                builder: (context) {
                  return AlertDialog(
                    content: Text("Logged in"),
                  );
                });
          });

          return Center(
            child: RaisedButton(
              onPressed: () {
                _authenController.invokeAuthen();
              },
              child: Text("Google Login"),
            ),
          );
        },
      ),
    );
  }
}
