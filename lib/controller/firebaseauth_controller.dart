import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController {
  static Future<User?> signIn(
      {required String email, required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> changePassword({required String password}) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  static Future<void> deleteAccount() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  static Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
