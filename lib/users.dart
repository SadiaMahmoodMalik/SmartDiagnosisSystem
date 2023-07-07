import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  String name;
  String gender;
  String date_of_birth;
  String emailAddress;

  User(this.id, this.name, this.date_of_birth, this.emailAddress, this.gender);

  // Convert user object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'date of birth': date_of_birth,
      'email': emailAddress,
    };
  }

  // Create user object from snapshot
  factory User.fromSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value as Map<dynamic, dynamic>?;

    if (value != null) {
      return User(
        snapshot.key!,
        value['name'] as String? ?? '',
        value['gender'] as String? ?? '',
        value['email'] as String? ?? '',
        value['date of birth'] as String? ?? '',
      );
    } else {
      throw Exception('Invalid snapshot value');
    }
  }
}

class DatabaseFuncPage extends StatefulWidget {
  @override
  _DatabaseFuncPageState createState() => _DatabaseFuncPageState();
}

class _DatabaseFuncPageState extends State<DatabaseFuncPage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<User> users = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    String key = '';
    databaseReference.child('user-signup').onChildAdded.listen((event) {
      print('Child added: ${event.snapshot.value}');
      setState(() {
        users.add(User.fromSnapshot(event.snapshot));
      });
    });

    databaseReference.child('user-signup').onChildChanged.listen((event) {
      print('Child changed: ${event.snapshot.value}');
      setState(() {
        String emailKey = event.snapshot.key!.replaceAll(',', '.');
        int userIndex = users.indexWhere((user) => user.emailAddress == emailKey);
        if (userIndex != -1) {
          users[userIndex] = User.fromSnapshot(event.snapshot);
        }
      });
    });

    databaseReference.child('user-signup').onChildRemoved.listen((event) {
      print('Child removed: ${event.snapshot.value}');
      setState(() {
        String? emailKey = event.snapshot.key?.replaceAll(',', '.');
        users.removeWhere((user) => user.emailAddress == emailKey);
      });
    });
  }

  void _addUser() {
    String name = nameController.text;
    String gender = genderController.text;
    String date_of_birth = birthController.text;
    String emailAddress = emailController.text;
    String emailKey = emailAddress.replaceAll('.', ',');

    if (name.isEmpty || gender.isEmpty) {
      return;
    }

    String? id = databaseReference.child('user-signup').push().key;

    databaseReference.child('user-signup/$emailKey').set(
      User(id!, name, gender, emailAddress, date_of_birth).toJson(),
    );

    nameController.clear();
    genderController.clear();
    emailController.clear();
    birthController.clear();
  }

  void _deleteUser(String id, String emailAddress) {
    String emailKey = emailAddress.replaceAll('.', ',');
    databaseReference.child('user-signup/$emailKey').remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: birthController,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addUser,
                  child: Text('Add User'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Column(
                    children: [
                      Text('Gender: ${user.gender}'),
                      Text('Date of Birth: ${user.date_of_birth}'),
                      Text('Email: ${user.emailAddress}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id, user.emailAddress),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DatabaseFuncPage(),
  ));
}
