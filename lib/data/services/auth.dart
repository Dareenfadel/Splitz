import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splitz/data/models/user.dart'; // Make sure this is the correct path

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?>? _userFromFirebaseUser(User? user) {
    if (user == null) {
      return null;
    }

    return _firestore.collection('users').doc(user.uid).get().then((userDoc) {
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(userData, user.uid);
      }
      return null;
    });
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user != null) {
        return await _userFromFirebaseUser(user);
      }
      return null;
    });
  }

  // Sign in anonymously
  Future<UserModel?> signInAnnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      await _storeUserData(user!, null);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = result.user;
      if (user != null) {
        return _userFromFirebaseUser(user);
      } else
        return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register
  Future<UserModel?> register(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      await _storeUserData(user!, name);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // User canceled sign-in
      }

      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Step 4: Store additional user info (user_type, restaurant_id, order_ids) in Firestore
        await _storeUserData(user, user.displayName);
        return _userFromFirebaseUser(user); // Return user with custom data
      }
      return null;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  // Store user data in Firestore
  Future<void> _storeUserData(User user, String? name) async {
    try {
      UserModel userModel = UserModel(
        uid: user.uid,
        userType: 'client', // Or 'manager', depending on your use case
        restaurantId: null, // null for clients, set for managers
        orderIds: [],
        name: name, // Empty list for now
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    } catch (e) {
      print("Error storing user data: $e");
    }
  }
}
