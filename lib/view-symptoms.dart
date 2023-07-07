import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewSymptoms extends StatefulWidget {
  @override
  _ViewSymptoms createState() => _ViewSymptoms();
}

class _ViewSymptoms extends State<ViewSymptoms> {
  late User _currentUser;
  DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('user-signup');

  String? name;
  String? email;
  String? birthDate;
  String? gender;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  void _fetchUserData() {
    String encodedEmail = _currentUser.email!.replaceAll('.', ',');
    _userRef.child(_currentUser.uid).child(encodedEmail).once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          name = userData['name'];
          email = userData['email'];
          birthDate = userData['date of birth'];
          gender = userData['gender'];
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _updateUserData() {
    String encodedEmail = _currentUser.email!.replaceAll('.', ',');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newName = name;
        String? newBirthDate = birthDate;
        String? newGender = gender;

        return AlertDialog(
          title: Text('Edit User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newBirthDate = value;
                },
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newGender = value;
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: ()
              {
                if (newName!.isNotEmpty && newGender!.isNotEmpty &&
                    newBirthDate!.isNotEmpty) {
                  name = newName;
                  gender = newGender;
                  birthDate = newBirthDate;
                  // Perform the necessary actions to save the updated user data
                  // For example, you can update the data in the database
                  // Once the update is complete, you can call _fetchUserData() to fetch the updated data and update the UI
                  _userRef.child(_currentUser.uid).child(encodedEmail).update({
                    'name': newName,
                    'gender': newGender,
                    'data of birth': newBirthDate,
                  });

                  setState(() {
                    name = newName;
                    birthDate = newBirthDate;
                    gender = newGender;
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  _fetchUserData(); // Fetch the updated data
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${name ?? 'Loading...'}'),
            Text('Email: ${email ?? 'Loading...'}'),
            Text('Birth Date: ${birthDate ?? 'Loading...'}'),
            Text('Gender: ${gender ?? 'Loading...'}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateUserData();
          print('Floating action button pressed');
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
