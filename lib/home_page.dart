import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/symptoms_form.dart';
import 'package:smartdiagnosissystem/profile_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Diagnosis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove the shadow below the app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Hi, I can help you learn more about your health.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SymptomsCollector()),
                );
              },
              child: Text(
                'Start Symptoms Assessment',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Features",
              style: TextStyle(color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeatureItem(
                    'images/symptoms_checker.png',
                    'Symptoms Checker',
                    'Check your symptoms and get suggestions for diagnosis.',
                  ),
                  _buildFeatureItem(
                    'images/medication_guide.jpeg',
                    'Medication Guide',
                    'Get information about the medicines prescribed to you.',
                  ),
                  _buildFeatureItem(
                    'images/health_tracker.jpeg',
                    'Health Tracker',
                    'Track your health parameters and get insights on your health.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Take care of your health',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFeatureItem(
                    'images/symptoms_checker.png',
                    'Symptoms Checker',
                    'Check your symptoms and get suggestions for diagnosis.',
                  ),
                  _buildFeatureItem(
                    'images/medication_guide.jpeg',
                    'Medication Guide',
                    'Get information about the medicines prescribed to you.',
                  ),
                  _buildFeatureItem(
                    'images/health_tracker.jpeg',
                    'Health Tracker',
                    'Track your health parameters and get insights on your health.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
        child: Icon(Icons.person),
      ),
    );
  }

  Widget _buildFeatureItem(String imagePath, String title, String description) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 20),
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}
