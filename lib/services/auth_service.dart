import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

sealed class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<bool> signUp(String email, String password, String username) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null) {
        await credential.user!.updateDisplayName(username);
      }

      return credential.user != null;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> signIn(String email, String password) async {
    try {
    final credential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user != null;
    } catch(e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> deleteAccount() async {

    /// Har qanday appda delete account qilinganda avvalo qayta sign in qilishi talab qilinadi.
    try {
      if(auth.currentUser != null) {
        await auth.currentUser!.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static User get user => auth.currentUser!;
}