import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Login Google
  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential =
    await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      await _saveUserToFirestore(user);
    }

    return user;
  }

  /// Lưu user Firestore (nếu chưa tồn tại)
  Future<void> _saveUserToFirestore(User user) async {
    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final snapshot = await doc.get();

    if (!snapshot.exists) {
      await doc.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
