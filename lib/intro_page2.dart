import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/intro_page1.dart';
import 'package:smartdiagnosissystem/intro_page3.dart';
import 'package:smartdiagnosissystem/login.dart';
import 'package:smartdiagnosissystem/sign_up.dart';
import 'package:smartdiagnosissystem/doctors.dart';

class IntroPage2 extends StatelessWidget {
  final doctors = generateDummyDoctors(20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset(
                'images/intro_image2.JPG',
                fit: BoxFit.cover,
              ),
              SizedBox(height: 32),
              Text(
                "Review Possible Causes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Uncover what may be causing your symptoms. ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IntroPage()),
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IntroPage3()),
                      );
                    },
                    icon: Icon(Icons.arrow_forward),
                   )
                ],
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
                  primary: Colors.blue, // Change the color of the button
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
            ],
          ),
        ),
      ),
    );
  }
}
