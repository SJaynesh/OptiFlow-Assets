import 'package:firebase_auth/firebase_auth.dart';

mixin AuthMixin {
  Future<Map<String, dynamic>> signInWithUserIdAddress(
      {required String userId, required String password});
}

class FireBaseAuthHelper with AuthMixin {
  FireBaseAuthHelper._();

  static final FireBaseAuthHelper firebaseAuth = FireBaseAuthHelper._();

  FirebaseAuth firebase = FirebaseAuth.instance;

  // Sign In Auth
  @override
  Future<Map<String, dynamic>> signInWithUserIdAddress(
      {required String userId, required String password}) async {
    Map<String, dynamic> res = {};
    try {
      UserCredential userCredential = await firebase.signInWithEmailAndPassword(
          email: userId, password: password);
      res['user'] = userCredential.user;
    } on FirebaseAuthException catch (e) {
      res['error'] = e.code;
    }
    return res;
  }
}
