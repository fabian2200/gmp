import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithCredential(AuthCredential credential) =>
    _auth.signInWithCredential(credential);
  
  Future<void> logout() => _auth.signOut();

  Stream<User> get currentUser => _auth.authStateChanges();

  
    
}