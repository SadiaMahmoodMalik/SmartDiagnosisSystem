import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/doctors.dart';
import 'package:smartdiagnosissystem/users.dart';
import 'package:smartdiagnosissystem/diabetes_doctor.dart';
import 'package:smartdiagnosissystem/complaints.dart';
import 'package:smartdiagnosissystem/review-complaints.dart';

class AdminDashboard extends StatelessWidget {
  final doctors = generateDummyDoctors(16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to manage doctors page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorsPage(doctors: doctors)),
                );
              },
              child: Text('Manage Doctors'),
            ),
            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                // Navigate to manage users page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DatabaseFuncPage()),
                );
              },
              child: Text('Manage Users'),
            ),
            SizedBox(height: 20.0,),
            ElevatedButton(
              onPressed: () {
                // Navigate to manage doctors page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewComplaintsPage()),
                );
              },
              child: Text('View Complaints'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}