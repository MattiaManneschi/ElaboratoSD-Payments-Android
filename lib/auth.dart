import 'package:firebase_auth/firebase_auth.dart';
import 'package:wally_app/main.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({   // metodo di log in 
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({  // metodo di sign up
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {  // metodo di sign out
    await _firebaseAuth.signOut();
  }

  Future<void> deleteUser() async { // metodo per cancellare l'account
    User? user = Auth().currentUser;
    user?.delete();
    db.doc(Auth().currentUser?.email).delete();
  }
}


// file che gestisce l'autenticazione utente;