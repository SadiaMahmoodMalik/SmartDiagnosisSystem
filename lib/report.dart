import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

class MedicalReportPage extends StatefulWidget {
  @override
  _MedicalReportPageState createState() => _MedicalReportPageState();
}

class _MedicalReportPageState extends State<MedicalReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Medical Report'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generateMedicalReport();
          },
          child: Text('Generate Report'),
        ),
      ),
    );
  }

  Future<void> generateMedicalReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(
              'Medical Report',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          );
        },
      ),
    );

    final output = await getExternalStorageDirectory(); // Use getApplicationDocumentsDirectory() for app documents directory.
    final outputFile = File('${output?.path}/medical_report.pdf');

    await outputFile.writeAsBytes(await pdf.save());

    print('Medical report generated: ${outputFile.path}');
  }
}

void main() {
  runApp(MaterialApp(
    home: MedicalReportPage(),
  ));
}
