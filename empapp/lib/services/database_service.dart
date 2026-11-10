import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _database =
      FirebaseDatabase.instance;

  // Save student details
  Future<void> saveStudentDetails({
    required String uid,
    required String fullName,
    required String studentId,
    required String email,
  }) async {
    await _database.ref('users/$uid').set({
      'fullName': fullName,
      'studentId': studentId,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  // Retrieve student details
  Future<Map<String, dynamic>?> getStudentDetails(
      String uid) async {
    final snapshot =
    await _database.ref('users/$uid').get();

    if (snapshot.exists && snapshot.value != null) {
      return Map<String, dynamic>.from(
        snapshot.value as Map,
      );
    }

    return null;
  }
}
