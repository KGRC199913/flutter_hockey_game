import 'package:flutter/material.dart';
import 'package:flutter_hockey_game/domain/log_in.dart';
import 'package:flutter_hockey_game/domain/sign_up.dart';
import 'package:flutter_hockey_game/model/user.dart';
import 'package:flutter_hockey_game/view/screen/game_mode_select.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final SignUpLogic signUpLogic = SignUpLogic();

  final LogInLogic logInLogic = LogInLogic();

  @override
  Widget build(BuildContext context) {
    signUpLogic.signUpStatus.listen((data) {
      if (data is SignUpError) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(data.message),
                ));
        return;
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return GameModeSelectPage();
      }));
    });

    logInLogic.logInStatus.listen((data) {
      if (data is LogInError) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(data.message),
            ));
        return;
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return GameModeSelectPage();
      }));
    });
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 40.0, right: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Air Hockey the Game"),
              SizedBox(
                height: 30.0,
              ),
              Text("Email"),
              TextField(
                controller: emailController,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Password"),
              TextField(
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 30.0,
              ),
              RaisedButton(
                child: Text("Log in"),
                onPressed: () {
                  logInLogic.userBehaviorSubject.add(
                      User(emailController.text, passwordController.text));
                },
              ),
              RaisedButton(
                child: Text("Sign up"),
                onPressed: () {
                  signUpLogic.userBehaviorSubject.add(
                      User(emailController.text, passwordController.text));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    signUpLogic.dispose();
    super.dispose();
  }
}
