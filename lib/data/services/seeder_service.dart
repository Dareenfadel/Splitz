import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:splitz/data/models/user.dart';
import 'package:splitz/data/services/auth.dart';

class SeederService {
  // Singleton
  static final SeederService _instance = SeederService._();
  factory SeederService() => _instance;
  SeederService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  int generateDummyNumber() {
    return faker.randomGenerator.integer(999);
  }

  Future<UserModel> createDummyClient({
    String? name,
    String? email,
    String? password,
  }) async {
    while (true) {
      var dummyNumber = generateDummyNumber();
      name ??= "Client $dummyNumber";
      email ??= "client$dummyNumber@gmail.com";
      password ??= "password";

      var snapShot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      var exists = snapShot.docs.isNotEmpty;

      if (!exists) {
        break;
      }
    }

    final user = await _auth.register(email, password, name);

    if (user == null) {
      throw Exception("Failed to create dummy client");
    }

    return user;
  }

  // Future<UserModel> createDummyManager({
  //   String? name,
  //   String? email,
  //   String? password,
  //   String? restaurantId,
  // }) async {
  //   var dummyNumber = generateDummyNumber();
  //   name ??= "Manager";
  //   email ??= "manager$dummyNumber@gmail.com";
  //   password ??= "password";

  //   final user = await _auth.register(email, password, name);

  //   if (user == null) {
  //     throw Exception("Failed to create dummy manager");
  //   }

  //   user.userType = 'manager';
  //   user.restaurantId = restaurantId;

  //   await _firestore.collection('users').doc(user.uid).set(user.toMap());

  //   return user;
  // }
}
