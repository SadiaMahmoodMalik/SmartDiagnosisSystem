import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MedicalReport extends StatefulWidget {
  @override
  _MedicalReportState createState() => _MedicalReportState();
}

class _MedicalReportState extends State<MedicalReport> {
  String pdfPath = '';
  String patientName = '';
  String diagnosedDisease = 'Diabetes';
  List<String> symptoms = ['Headache', 'High blood pressure', 'Chest pain'];
  List<String> recommendedDoctors = ['Dr. Smith', 'Dr. Johnson'];
  List<String> recommendedHospitals = ['ABC Hospital', 'XYZ Clinic'];

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    fetchPatientName();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> fetchPatientName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? displayName = user.displayName;
      setState(() {
        patientName = displayName ?? 'John Doe';
      });
    }
  }



  Future<void> generatePDFReport() async {
    final pdf = pw.Document();

    final fontData = await rootBundle.load('fonts/OpenSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Medical Report',
                    style: pw.TextStyle(fontSize: 20, font: ttf)),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Patient Name: $patientName',
                  style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Diagnosed Disease: $diagnosedDisease',
                  style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.SizedBox(height: 10),
              pw.Text('Symptoms:', style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.Bullet(
                text: symptoms.join(', '),
                style: pw.TextStyle(fontSize: 14, font: ttf),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Recommended Doctors:',
                  style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.ListView.builder(
                itemCount: recommendedDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = recommendedDoctors[index];
                  return pw.Bullet(
                    text: '\u2022 $doctor',
                    style: pw.TextStyle(fontSize: 14, font: ttf),
                  );
                },
              ),
              pw.SizedBox(height: 10),
              pw.Text('Recommended Hospitals:',
                  style: pw.TextStyle(fontSize: 16, font: ttf)),
              pw.ListView.builder(
                itemCount: recommendedHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = recommendedHospitals[index];
                  return pw.Bullet(
                    text: '\u2022 $hospital',
                    style: pw.TextStyle(fontSize: 14, font: ttf),
                  );
                },
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/medical_report.pdf");
    await file.writeAsBytes(await pdf.save());
    print('PDF report generated successfully.');
    print('PDF file path: ${file.path}');
    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pdfPath.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Medical Report'),
        ),
        body: PDFView(
          filePath: pdfPath,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Medical Report'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Generate Report'),
            onPressed: () {
              generatePDFReport();
            },
          ),
        ),
      );
    }
  }
}
