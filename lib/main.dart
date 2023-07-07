import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/admin_login.dart';
import 'package:smartdiagnosissystem/doctors.dart';
import 'package:smartdiagnosissystem/intro_page1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smartdiagnosissystem/heart_disease.dart';
import 'package:smartdiagnosissystem/diabetes.dart';
import 'package:smartdiagnosissystem/generate_report.dart';
import 'package:smartdiagnosissystem/admin_dashboard.dart';
import 'package:smartdiagnosissystem/heart_disease.dart';
import 'package:smartdiagnosissystem/diabetes_doctor.dart';
import 'package:smartdiagnosissystem/heart_doctors.dart';
import 'package:smartdiagnosissystem/doctor_login.dart';
import 'package:smartdiagnosissystem/doctors.dart';
import 'package:smartdiagnosissystem/home_page.dart';
import 'package:smartdiagnosissystem/doctor_login.dart';
import 'package:smartdiagnosissystem/complaints.dart';
import 'package:smartdiagnosissystem/profile_page.dart';
import 'package:smartdiagnosissystem/review-complaints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Diagnosis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroPage(),
    );
  }
}
