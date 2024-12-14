import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitz/data/models/order.dart';
import 'package:splitz/data/models/order_item.dart';
import 'package:splitz/data/models/user.dart';

class UsersService {
  UsersService._();

  static final UsersService _instance = UsersService._();

  factory UsersService() => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, UserModel>> fetchUsersByIds(Set<String> usersIds) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: usersIds)
          .get();

      return querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).fold<Map<String, UserModel>>({}, (acc, user) {
        acc[user.uid] = user;
        return acc;
      });
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
  Future<bool> haveCurrentOrder() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('currentOrderId', isNull: false)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }
}
