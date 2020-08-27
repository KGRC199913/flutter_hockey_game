import 'package:flutter_hockey_game/domain/disposable.dart';
import 'package:flutter_hockey_game/model/repository/authenticate_repo.dart';
import 'package:flutter_hockey_game/model/user.dart';
import 'package:rxdart/rxdart.dart';

class SignUpLogic with Disposable {
  AuthenticateRepositoryImpl _repo = AuthenticateRepositoryImpl();

  BehaviorSubject<User> userBehaviorSubject = BehaviorSubject<User>();

  SignUpLogic() {
    userBehaviorSubject.listen((data) {
      _repo
          .signUp(data)
          .then((value) => _signUpStatusSubject.add(SignUpSuccess("Success")))
          .catchError((err, stacktrace) {
            print(err);
            print(stacktrace);
            _signUpStatusSubject.add(SignUpError(err.toString()));
      });
    });
  }

  BehaviorSubject<SignUpStatus> _signUpStatusSubject =
  BehaviorSubject<SignUpStatus>();

  Stream get signUpStatus => _signUpStatusSubject.stream;

  @override
  void dispose() {
    userBehaviorSubject.close();
    _signUpStatusSubject.close();
  }
}

class SignUpStatus {
  final String _message;

  SignUpStatus(String message) : _message = message;

  String get message => _message;
}

class SignUpSuccess extends SignUpStatus {
  SignUpSuccess(String message) : super(message);
}

class SignUpError extends SignUpStatus {
  SignUpError(String message) : super(message);
}
