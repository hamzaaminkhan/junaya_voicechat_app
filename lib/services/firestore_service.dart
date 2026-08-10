import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Users Collection
  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  /// Create User
  Future<void> createUser(UserModel user) async {
    try {
      await _users.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create user.');
    }
  }

  /// Get User by UID
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch user.');
    }
  }

  /// Update entire user document
  Future<void> updateUser(UserModel user) async {
    try {
      await _users.doc(user.uid).update({
        ...user.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    } catch (_) {
      throw Exception('Failed to update user.');
    }
  }

  /// Update Full Name
  Future<void> updateFullName(String uid, String fullName) async {
    try {
      await _users.doc(uid).update({
        'fullName': fullName.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update Username
  Future<void> updateUsername(String uid, String username) async {
    try {
      await _users.doc(uid).update({
        'username': username.trim().toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update Profile Image
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    try {
      await _users.doc(uid).update({
        'profileImage': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update Online Status
  Future<void> updateOnlineStatus(String uid, bool isOnline) async {
    try {
      await _users.doc(uid).update({
        'isOnline': isOnline,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Keep Firestore email verification state aligned with Firebase Auth.
  Future<void> updateEmailVerification(String uid, bool isVerified) async {
    try {
      await _users.doc(uid).update({
        'isEmailVerified': isVerified,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update VIP Status
  Future<void> updateVipStatus(String uid, bool isVip) async {
    try {
      await _users.doc(uid).update({
        'isVip': isVip,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update Coins
  Future<void> updateCoins(String uid, int coins) async {
    try {
      await _users.doc(uid).update({
        'coins': coins,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Update Diamonds
  Future<void> updateDiamonds(String uid, int diamonds) async {
    try {
      await _users.doc(uid).update({
        'diamonds': diamonds,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Add Coins (Transaction Safe)
  Future<void> addCoins(String uid, int amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _users.doc(uid);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('User not found.');
        }

        final currentCoins = snapshot.data()?['coins'] ?? 0;

        transaction.update(docRef, {
          'coins': currentCoins + amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Remove Coins (Cannot Go Below Zero)
  Future<void> removeCoins(String uid, int amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _users.doc(uid);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('User not found.');
        }

        final currentCoins = snapshot.data()?['coins'] ?? 0;

        final newCoins = (currentCoins - amount).clamp(0, 1 << 31);

        transaction.update(docRef, {
          'coins': newCoins,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Add Diamonds (Transaction Safe)
  Future<void> addDiamonds(String uid, int amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _users.doc(uid);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('User not found.');
        }

        final currentDiamonds = snapshot.data()?['diamonds'] ?? 0;

        transaction.update(docRef, {
          'diamonds': currentDiamonds + amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Remove Diamonds (Cannot Go Below Zero)
  Future<void> removeDiamonds(String uid, int amount) async {
    try {
      await _firestore.runTransaction((transaction) async {
        final docRef = _users.doc(uid);
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception('User not found.');
        }

        final currentDiamonds = snapshot.data()?['diamonds'] ?? 0;

        final newDiamonds = (currentDiamonds - amount).clamp(0, 1 << 31);

        transaction.update(docRef, {
          'diamonds': newDiamonds,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Delete User Document
  Future<void> deleteUser(String uid) async {
    try {
      await _users.doc(uid).delete();
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Listen to user document in real-time
  Stream<UserModel?> userStream(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    });
  }

  /// Check if username already exists
  Future<bool> usernameExists(String username) async {
    try {
      final result = await _users
          .where('username', isEqualTo: username.trim().toLowerCase())
          .limit(1)
          .get();

      return result.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Check if email already exists
  Future<bool> emailExists(String email) async {
    try {
      final result = await _users
          .where('email', isEqualTo: email.trim().toLowerCase())
          .limit(1)
          .get();

      return result.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  /// Check if user document exists
  Future<bool> userExists(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      return doc.exists;
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }
}
