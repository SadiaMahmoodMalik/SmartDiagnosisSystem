import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smartdiagnosissystem/Doctor_Profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Login',
      home: DoctorLoginPage(),
    );
  }
}

class DoctorLoginPage extends StatefulWidget {
  @override
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final database = FirebaseDatabase.instance.reference();
  final emailController = TextEditingController(); // Controller for email text field
  final passwordController = TextEditingController(); // Controller for password text field

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController, // Assign the email controller
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController, // Assign the password controller
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Login button pressed
                // Retrieve email and password values from text fields
                String email = emailController.text;
                String password = passwordController.text;

                // Query the Realtime Database for the entered email
                database.child('doctors').orderByChild('email_address').equalTo(email).once().then((DatabaseEvent snapshot) {
                  if (snapshot.snapshot.value != null) {
                    // Email exists in the database
                    Map<dynamic, dynamic>? doctors = snapshot.snapshot.value as Map?;
                    Map<dynamic, dynamic> doctor = doctors!.values.first;
                    // Check if the entered password matches the stored password
                    if (password == 'doctor_123') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorProfilePage(doctorEmail: email,),
                        ),
                      );
                      print('Login successful!');
                      // TODO: Navigate to the doctor's account page
                    } else {
                      // Incorrect password
                      print('Incorrect password!');
                    }
                  } else {
                    // Email does not exist in the database
                    print('Email does not exist!');
                  }
                });
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
