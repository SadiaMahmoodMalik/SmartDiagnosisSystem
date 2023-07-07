import 'package:flutter/material.dart';
import 'package:smartdiagnosissystem/heart_disease.dart';
import 'package:smartdiagnosissystem/diabetes.dart';

class SymptomsCollector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Collector'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HeartSymptomsForm()),
                );
              },
              child: Text('Heart Disease'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiabetesSymptomsForm()),
                );
              },
              child: Text('Diabetes'),
            ),
          ],
        ),
      ),
    );
  }
}

