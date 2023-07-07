import 'package:flutter/material.dart';

class PredictionPage extends StatefulWidget {
  final String disease;
  final String probability;

  PredictionPage({required this.disease, required this.probability});

  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Predicted Disease:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.disease,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Probability:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              widget.probability,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}