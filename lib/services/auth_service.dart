import 'package:firebase_auth/firebase_auth.dart';

class AuthenticateHelpler{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user=>_auth.currentUser;

  Future signIn({required String email, required String password})async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future  signOut() async {
    await _auth.signOut();
  }
}


// got to project folder
// dart pub global activate flutterfire_cli
// firebase logout
// firebase login
// // incase above two not run
// firebase login --reauth
// flutterfire configure