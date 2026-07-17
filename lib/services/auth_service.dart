import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';


class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Current Firebase User
  User? get currentUser => _auth.currentUser;

  /// Authentication State Changes
  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  /// Sign Up
  Future<UserCredential> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Check username availability
      final usernameExists =
      await FirestoreService.instance.usernameExists(username);

      if (usernameExists) {
        throw Exception('Username is already taken.');
      }

      // Create Firebase Account
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Failed to create user.');
      }

      // Send Verification Email
      await user.sendEmailVerification();

      // Create Firestore User
      final userModel = UserModel(
        uid: user.uid,
        fullName: fullName,
        username: username,
        email: email,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await FirestoreService.instance.createUser(userModel);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    } catch (e) {
      rethrow;
    }
  }

  /// Login
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Firebase Error Messages
  String _firebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email is already registered.';

      case 'invalid-email':
        return 'Invalid email address.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'user-not-found':
        return 'User not found.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'too-many-requests':
        return 'Too many attempts.';

      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Send Password Reset Email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Send Email Verification Again
  Future<void> sendEmailVerification() async {
    try {
      final user = currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Reload Current User
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Check Email Verification Status
  Future<bool> isEmailVerified() async {
    await reloadUser();
    return currentUser?.emailVerified ?? false;
  }

  /// Delete Current Account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;

      if (user == null) {
        throw Exception('No authenticated user.');
      }

      // Delete Firestore document first
      await FirestoreService.instance.deleteUser(user.uid);

      // Delete Firebase account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// Re-authenticate User
  Future<void> reAuthenticate({
    required String email,
    required String password,
  }) async {
    try {
      final user = currentUser;

      if (user == null) {
        throw Exception('No authenticated user.');
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }
}