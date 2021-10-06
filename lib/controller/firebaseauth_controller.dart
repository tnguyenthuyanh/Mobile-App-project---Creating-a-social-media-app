import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController {
  static Future<User?> signIn({required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}