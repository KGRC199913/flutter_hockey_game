import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthenRepository {
  void authen();

  void dispose();

  Stream<AuthenStatus> get authenstatus;
}

class FirebaseAuthenRepository extends AuthenRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void authen() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    _authenStatus.sink.add(AuthenStatus.AUTHENTICATED);
  }

  BehaviorSubject<AuthenStatus> _authenStatus =
      new BehaviorSubject.seeded(AuthenStatus.UNAUTHENTICATED);

  Stream<AuthenStatus> get authenstatus => _authenStatus;

  void dispose() {
    _authenStatus.close();
  }
}

enum AuthenStatus { UNAUTHENTICATED, AUTHENTICATED, PANIC }
