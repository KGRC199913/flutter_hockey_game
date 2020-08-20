import 'package:flutter_hockey_game/model/authen.dart';

abstract class AuthenController {
  void invokeAuthen();
}

class AuthenControllerImp extends AuthenController {
  final AuthenRepository _authenRepository;

  AuthenControllerImp(AuthenRepository authenRepository)
      : _authenRepository = authenRepository;

  @override
  void invokeAuthen() {
    _authenRepository.authen();
  }
}
