import 'dart:convert';

import 'package:flutter_hockey_game/model/user.dart';
import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _client = HttpClient._internal();

  HttpClient._internal();

  factory HttpClient() {
    return _client;
  }

  final client = http.Client();
  static const url = "http://10.0.2.2:3001";

  Future<User> signUp(User user) async {
    print(jsonEncode(user));
    var res = await client.post(
        url + "/users",
        headers: {"content-type": "application/json"},
        body: jsonEncode(user));
    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }
    return User.fromJson(jsonDecode(res.body));
  }

  Future<User> logIn(User user) async {
    print(user);
    var res = await client.post(url + "/users/login",
        headers: {"content-type": "application/json"},
        body: jsonEncode(user));
    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }
    return User.fromJson(jsonDecode(res.body));
  }
}
