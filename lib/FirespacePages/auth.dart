import 'package:RecipeApp/Classes/user.dart';
import 'package:RecipeApp/FirespacePages/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //Create User Obj Based on UID
  User _userFromFirebase(FirebaseUser usr) {
    return usr != null ? User(uid: usr.uid, email: usr.email) : null;
  }

  //Auth Change Users Stream

  Stream<User> get userStream {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  //Sign In Email
  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //Register Email
  Future registerWithEmailAndPass(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //Create New Doc With UID.
      // await DatabaseService(uid: user.uid)
      //     .updateUserData(null, null, null, null);
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //Sign In Google

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return 'signInWithGoogle succeeded: $user';
  }

  //Sign Out Google
  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out");
  }

  //Sign Out
  Future signOut() async {
    try {
      await googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _handleSignIn() async {
    try {
      // hold the instance of the authenticated user
      FirebaseUser user;
      // flag to check whether we're signed in already
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        // if so, return the current user
        user = await _auth.currentUser();
      } else {
        try {
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          // get the credentials to (access / id token)
          // to sign in via Firebase Authentication
          final AuthCredential credential = GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          user = (await _auth.signInWithCredential(credential)).user;
        } catch (e) {
          print(e.toString());
        }
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    User usr = _userFromFirebase(user);
    return usr;
  }
}
