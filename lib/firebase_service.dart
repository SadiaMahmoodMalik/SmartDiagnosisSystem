import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user!.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user!.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void saveUserInfo(String userId, String name, String email, String date_of_birth, String gender) {
    try {_database.child('user-signup').child(email.replaceAll('.', ',')).set({
      'name': name,
      'email': email,
      'date of birth': gender,
      'gender': date_of_birth,
      'id': userId,
    });
    }
        catch (error) {
          // Handle the error appropriately
          print('Error saving user info: $error');
          throw error;
        }
  }
}
