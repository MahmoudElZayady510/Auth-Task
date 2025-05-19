import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> logout();

  Future<void> createUserDocument(String userId, Map<String, dynamic> userData);
}

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseAuthRepository(this._firebaseAuth , this._firestore);

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      final userCreds = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // return userCreds.user; //added
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'invalid-email':
          throw Exception('Invalid email address.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        default:
          throw Exception('An error occurred. Please try again later.');
      }
    } catch (e) {
      // Handle other unexpected exceptions
      throw Exception('An unknown error occurred.');
    }
  }

  @override
  Future<void> logout() async{
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // Re-throw the error for handling in the UI
    }
  }

  @override
  Future<User?> signUp(String email, String password) async{
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message); // Re-throw the error for handling in the UI
    }
  }
  Future<void> createUserDocument(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print(e);
      throw Exception('Error creating user document: $e');
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null; // المستخدم لغى العملية

        final GoogleSignInAuthentication googleAuth = await googleUser
            .authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          bool isNewUser = userCredential.additionalUserInfo?.isNewUser ??
              false;

          if (isNewUser) {
            print("🎉 مستخدم جديد!");
            await createUserDocument(user.uid, {
              'email': user.email,
              'fullName': user.displayName,
              'createdAt': FieldValue.serverTimestamp(),
            }); // تخزين البيانات لأول مرة
          } else {
            print("🔄 مستخدم قديم!");
          }
          return user;
        }
        return null;
      } catch (e) {
        print("❌ خطأ في تسجيل الدخول بجوجل: $e");
        return null;
      }
    }
  }
