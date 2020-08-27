import 'package:flutter_hockey_game/domain/disposable.dart';
import 'package:flutter_hockey_game/model/repository/authenticate_repo.dart';
import 'package:flutter_hockey_game/model/user.dart';
import 'package:rxdart/rxdart.dart';

class LogInLogic with Disposable {
  AuthenticateRepositoryImpl _repo = AuthenticateRepositoryImpl();

  BehaviorSubject<User> userBehaviorSubject = BehaviorSubject<User>();

  LogInLogic() {
    userBehaviorSubject.listen((data) {
      _repo
          .logIn(data)
          .then((value) => _logInStatusSubject.add(LogInSuccess("Success")))
          .catchError(
              (err) => _logInStatusSubject.add(LogInError(err.toString())));
    });
  }

  BehaviorSubject<LogInStatus> _logInStatusSubject =
      BehaviorSubject<LogInStatus>();

  Stream get logInStatus => _logInStatusSubject.stream;

  @override
  void dispose() {
    userBehaviorSubject.close();
    _logInStatusSubject.close();
  }
}

class LogInStatus {
  final String _message;

  LogInStatus(String message) : _message = message;

  String get message => _message;
}

class LogInSuccess extends LogInStatus {
  LogInSuccess(String message) : super(message);
}

class LogInError extends LogInStatus {
  LogInError(String message) : super(message);
}
