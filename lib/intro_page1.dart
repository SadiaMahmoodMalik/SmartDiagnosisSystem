import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/doctor_login.dart';
import 'package:smartdiagnosissystem/intro_page2.dart';
import 'package:smartdiagnosissystem/login.dart';
import 'package:smartdiagnosissystem/sign_up.dart';
import 'package:smartdiagnosissystem/admin_login.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset(
                'images/intro_image1.jpeg',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 32),
              Text(
                "Let's get started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Personalize your health profile and manage your medical data with free accounts. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => IntroPage2()),
                        );
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()),
                  );
                },
                child: SizedBox(
                  width: 200, // Adjust this value to make the button longer
                  child: Text(
                    "Log In",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Adjust this value to change the font size
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change the color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Make the button rounded
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: SizedBox(
                  width: 200, // Adjust this value to make the button longer
                  child: Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Adjust this value to change the font size
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change the color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Make the button rounded
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()),
                  );
                },
                child: SizedBox(
                  width: 200, // Adjust this value to make the button longer
                  child: Text(
                    "Admin Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Adjust this value to change the font size
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change the color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Make the button rounded
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorLoginPage()),
                  );
                },
                child: SizedBox(
                  width: 200, // Adjust this value to make the button longer
                  child: Text(
                    "Doctor Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Adjust this value to change the font size
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change the color of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Make the button rounded
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
