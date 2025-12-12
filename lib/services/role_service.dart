import 'package:cloud_firestore/cloud_firestore.dart';

class RoleService {
  static Future<String> getRole(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!doc.exists) return 'user';

    return (doc.data()?['role'] ?? 'user').toString();
  }
}
