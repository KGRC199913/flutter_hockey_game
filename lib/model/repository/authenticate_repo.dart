import 'package:flutter_hockey_game/model/user.dart';
import 'package:flutter_hockey_game/network/httpclient.dart';

abstract class AuthenticateRepository {
  Future<User> signUp(User user);
  Future<User> logIn(User user);
}

class AuthenticateRepositoryImpl extends AuthenticateRepository {
  static final AuthenticateRepositoryImpl _impl = AuthenticateRepositoryImpl._internal();

  AuthenticateRepositoryImpl._internal();

  factory AuthenticateRepositoryImpl() => _impl;

  var client = HttpClient();

  @override
  Future<User> signUp(User user) {
    return client.signUp(user);
  }

  @override
  Future<User> logIn(User user) {
    return client.logIn(user);
  }
}