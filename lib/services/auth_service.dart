import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

sealed class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<bool> signUp(String email, String password, String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user != null;
    } catch(e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static Future<bool> deleteAccount() async {

    /// Har qanday appda delete account qilinganda avvalo qayta sign in qilishi talab qilinadi.
    try {
      if(_auth.currentUser != null) {
        await _auth.currentUser!.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    }
  }

  static User get user => _auth.currentUser!;
}