import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final normalizedName = fullName.trim();
    final normalizedUsername = username.trim().toLowerCase();
    final normalizedEmail = email.trim().toLowerCase();

    try {
      final usernameExists = await FirestoreService.instance.usernameExists(
        normalizedUsername,
      );

      if (usernameExists) {
        throw Exception('Username is already taken.');
      }

      final credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Failed to create user.');
      }

      await user.updateDisplayName(normalizedName);

      final now = Timestamp.now();
      final userModel = UserModel(
        uid: user.uid,
        fullName: normalizedName,
        username: normalizedUsername,
        email: normalizedEmail,
        isOnline: false,
        isEmailVerified: user.emailVerified,
        createdAt: now,
        updatedAt: now,
      );

      try {
        await FirestoreService.instance.createUser(userModel);
      } catch (_) {
        // Avoid leaving a Firebase Auth account without its Junaya profile.
        try {
          await user.delete();
        } catch (_) {}
        rethrow;
      }

      // Email delivery can fail temporarily. The verification screen also
      // offers a resend action, so an already-created account remains usable.
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException {
        // Best effort. Do not invalidate the newly created account.
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null && user.emailVerified) {
        await _syncVerificationState(user);
        await _setOnlineStatus(user.uid, true);
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) async {
    try {
      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user == null) {
        throw Exception('Unable to verify this phone number.');
      }

      final exists = await FirestoreService.instance.userExists(user.uid);
      if (!exists) {
        final suffix = user.uid.length > 8
            ? user.uid.substring(user.uid.length - 8)
            : user.uid;
        final now = Timestamp.now();

        await FirestoreService.instance.createUser(
          UserModel(
            uid: user.uid,
            fullName: user.displayName?.trim().isNotEmpty == true
                ? user.displayName!.trim()
                : 'Junaya User',
            username: 'user_$suffix'.toLowerCase(),
            email: user.email ?? '',
            phoneNumber: user.phoneNumber ?? '',
            isOnline: true,
            isEmailVerified: user.emailVerified,
            createdAt: now,
            updatedAt: now,
          ),
        );
      } else {
        await _setOnlineStatus(user.uid, true);
      }

      return result;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> signOut() async {
    final uid = currentUser?.uid;

    if (uid != null) {
      await _setOnlineStatus(uid, false);
    }

    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<User?> reloadUser() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      await user.reload();
      return currentUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<bool> isEmailVerified() async {
    final user = await reloadUser();
    final verified = user?.emailVerified ?? false;

    if (user != null && verified) {
      await _syncVerificationState(user);
    }

    return verified;
  }

  Future<void> syncCurrentUserState() async {
    final user = currentUser;
    if (user == null) return;

    await _syncVerificationState(user);
    if (user.email == null || user.emailVerified) {
      await _setOnlineStatus(user.uid, true);
    }
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No authenticated user.');
    }

    try {
      await FirestoreService.instance.deleteUser(user.uid);
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> reAuthenticate({
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('No authenticated user.');
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> _syncVerificationState(User user) async {
    try {
      final exists = await FirestoreService.instance.userExists(user.uid);
      if (!exists) return;

      await FirestoreService.instance.updateEmailVerification(
        user.uid,
        user.emailVerified,
      );
    } catch (_) {
      // Firestore sync should not block Firebase authentication.
    }
  }

  Future<void> _setOnlineStatus(String uid, bool isOnline) async {
    try {
      final exists = await FirestoreService.instance.userExists(uid);
      if (!exists) return;

      await FirestoreService.instance.updateOnlineStatus(uid, isOnline);
    } catch (_) {
      // Presence is best effort; auth should remain available offline.
    }
  }

  String _firebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Check your internet connection and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'requires-recent-login':
        return 'Please sign in again before continuing.';
      case 'invalid-verification-code':
        return 'The verification code is incorrect.';
      case 'session-expired':
        return 'The verification code expired. Request a new code.';
      case 'missing-verification-code':
        return 'Enter the verification code.';
      case 'quota-exceeded':
        return 'SMS verification quota has been reached. Try again later.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
