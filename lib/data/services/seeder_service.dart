import 'package:cloud_firestore/cloud_firestore.dart';
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
    return DateTime.now().millisecondsSinceEpoch;
  }
  
  Future<UserModel> createDummyClient({
    String? name,
    String? email,
    String? password,
  }) async {
    var dummyNumber = generateDummyNumber();
    name ??= "Client $dummyNumber";
    email ??= "client$dummyNumber@gmail.com";
    password ??= "password";
    
    final user = await _auth.register(email, password, name);
    
    if (user == null) {
      throw Exception("Failed to create dummy client");
    }
    
    return user;
  }
}
