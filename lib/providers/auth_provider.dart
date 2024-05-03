import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppUser? _user;
  AppUser? get user => _user;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? firebaseUser = authResult.user;

        _user = AppUser(
          uid: firebaseUser!.uid,
          displayName: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoURL: firebaseUser.photoURL,
        );
        print(_user);
        notifyListeners();
      } else {
        print('Google Sign-In was canceled or failed.');
      }
    } on PlatformException catch (e) {
      if (e.code == 'sign_in_canceled') {
        print('Google Sign-In was canceled by the user.');
      } else if (e.code == 'sign_in_failed') {
        print('Google Sign-In failed: ${e.message}');
      } else {
        print('Error signing in with Google: ${e.code} - ${e.message}');
      }
    } catch (error, stackTrace) {
      print('Error signing in with Google: $error');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
