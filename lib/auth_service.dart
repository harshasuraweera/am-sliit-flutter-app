import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
  );

  //Email and Password Sign Up

  // ignore: missing_return
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
  }

  //Email and Password Sign In

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password))
        .user
        .uid;
  }


  // Sign Out
  signOut() async {
    return await _firebaseAuth.signOut();
  }




}