import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartdiagnosissystem/generate_report.dart';
import 'package:smartdiagnosissystem/heart_doctors.dart';


class HeartSymptomsForm extends StatefulWidget {
  @override
  _HeartSymptomsForm createState() => _HeartSymptomsForm();
}

class _HeartSymptomsForm extends State<HeartSymptomsForm> {
  TextEditingController highBPController = TextEditingController();
  TextEditingController highCholController = TextEditingController();
  TextEditingController cholCheckController = TextEditingController();
  TextEditingController bmiController = TextEditingController();
  TextEditingController smokerController = TextEditingController();
  TextEditingController strokeController = TextEditingController();
  TextEditingController diabetesController = TextEditingController();
  TextEditingController physActivityController = TextEditingController();
  TextEditingController fruitsController = TextEditingController();
  TextEditingController veggiesController = TextEditingController();
  TextEditingController hvyAlcoholConsumpController = TextEditingController();
  TextEditingController anyHealthcareController = TextEditingController();
  TextEditingController noDocbcCostController = TextEditingController();
  TextEditingController genHlthController = TextEditingController();
  TextEditingController mentHlthController = TextEditingController();
  TextEditingController physHlthController = TextEditingController();
  TextEditingController diffWalkController = TextEditingController();
  TextEditingController sexController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  String result = '';
  User? _currentUser;


  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  Future<void> fetchCurrentUser() async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      _currentUser = auth.currentUser;
    });
  }

  Future<void> predictPlacement() async {
    // String url = "https://2d4d-39-45-214-19.ngrok-free.app/predict";

    // Check if the required fields are empty
    if (highBPController.text.isEmpty || !isNumeric(highBPController.text) ||
        highCholController.text.isEmpty || !isNumeric(highCholController.text) ||
        cholCheckController.text.isEmpty || !isNumeric(cholCheckController.text) ||
        bmiController.text.isEmpty || !isNumeric(bmiController.text) ||
        smokerController.text.isEmpty || !isNumeric(smokerController.text) ||
        strokeController.text.isEmpty || !isNumeric(strokeController.text) ||
        diabetesController.text.isEmpty || !isNumeric(diabetesController.text) ||
        physActivityController.text.isEmpty || !isNumeric(physActivityController.text) ||
        fruitsController.text.isEmpty || !isNumeric(fruitsController.text) ||
        veggiesController.text.isEmpty ||
        hvyAlcoholConsumpController.text.isEmpty || !isNumeric(hvyAlcoholConsumpController.text) ||
        anyHealthcareController.text.isEmpty || !isNumeric(anyHealthcareController.text) ||
        noDocbcCostController.text.isEmpty || !isNumeric(noDocbcCostController.text) ||
        genHlthController.text.isEmpty || !isNumeric(genHlthController.text) ||
        mentHlthController.text.isEmpty || !isNumeric(mentHlthController.text) ||
        physHlthController.text.isEmpty || !isNumeric(physHlthController.text) ||
        diffWalkController.text.isEmpty || !isNumeric(diffWalkController.text) ||
        sexController.text.isEmpty ||
        ageController.text.isEmpty || !isNumeric(ageController.text) ||
        educationController.text.isEmpty ||
        incomeController.text.isEmpty || !isNumeric(incomeController.text)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Missing Information"),
            content: Text("Please fill in all the required fields with numeric values."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }




    // Perform the API request and prediction
    Map<String, String> params = {
      "HighBP": highBPController.text,
      "HighChol": highCholController.text,
      "CholCheck": cholCheckController.text,
      "BMI": bmiController.text,
      "Smoker": smokerController.text,
      "Stroke": strokeController.text,
      "Diabetes": diabetesController.text,
      "PhysActivity": physActivityController.text,
      "Fruits": fruitsController.text,
      "Veggies": veggiesController.text,
      "HvyAlcoholConsump": hvyAlcoholConsumpController.text,
      "AnyHealthcare": anyHealthcareController.text,
      "NoDocbcCost": noDocbcCostController.text,
      "GenHlth": genHlthController.text,
      "MentHlth": mentHlthController.text,
      "PhysHlth": physHlthController.text,
      "DiffWalk": diffWalkController.text,
      "Sex": sexController.text,
      "Education": educationController.text,
      "Income": incomeController.text,
      "Age": ageController.text,
      "Result": result,
    };
    print("params");
    print(params);
    var url = Uri.parse('https://smart-diagnosis.herokuapp.com/predict');

    var request = http.MultipartRequest('POST', url);
    request.fields.addAll(params);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        Map<String, dynamic> jsonMap = jsonDecode(responseBody);
        double heartDiseaseValue = jsonMap['HeartDiseaseorAttack'];
        String heartDiseaseString = heartDiseaseValue.toString();

        setState(() {
          result = heartDiseaseString == "1.0" ? "Heart Disease" : "Not a Heart Disease";
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response}');
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print(error);
    }
  }

  void _showPredictionDialog(BuildContext context) {
    // Populate the selected symptoms and predicted disease
    List<String> selectedSymptoms = [
      'High Blood Pressure: ${highBPController.text}',
      'High Cholesterol: ${highCholController.text}',
      'Cholesterol Check: ${cholCheckController.text}',
      'BMI: ${bmiController.text}',
      'Smoker: ${smokerController.text}',
      'Stroke: ${strokeController.text}',
      'Diabetes: ${diabetesController.text}',
      'Physical Activity: ${physActivityController.text}',
      'Fruits Consumption: ${fruitsController.text}',
      'Vegetables Consumption: ${veggiesController.text}',
      'Heavy Alcohol Consumption: ${hvyAlcoholConsumpController.text}',
      'Any Healthcare: ${anyHealthcareController.text}',
      'No Doctor Visits Due to Cost: ${noDocbcCostController.text}',
      'General Health: ${genHlthController.text}',
      'Mental Health: ${mentHlthController.text}',
      'Physical Health: ${physHlthController.text}',
      'Difficulty Walking: ${diffWalkController.text}',
      'Sex: ${sexController.text}',
      'Age: ${ageController.text}',
      'Education: ${educationController.text}',
      'Income: ${incomeController.text}',
    ];

    String predictedDisease = '$result'; // Replace with the actual predicted disease
    if (predictedDisease != null) {
      try {
        _userRef.child(_currentUser!.email!.replaceAll('.', ',')).child('predicted-disease').set({
          'Predicted Disease': '$result',
        });
        print('Predcited Disease saved to Firebase');
      } catch (error) {
        print('Failed to save predicted disease to Firebase: $error');
      }
    }
    else{
      Text('disease not predicted');
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Report',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Selected Symptoms:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  selectedSymptoms.join(', '),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Text(
                  'Predicted Disease:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  predictedDisease,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    if (predictedDisease == 'Heart Disease')
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          child: Text('Recommend doctor and hospital'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListPage(),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('user-signup');
  String? name;
  String email = '';
  void _fetchUserData() {
    _userRef.child(_currentUser!.email!.replaceAll('.', ',')).once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          name = userData['name'];
          email = userData['email'];
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future<void> _predictDisease() async {
    // Call the predictPlacement function
    predictPlacement();
    if (_currentUser != null) {
      try {
        _userRef.child(_currentUser!.email!.replaceAll('.', ',')).child('symptoms').set({
          'HighBP': highBPController.text,
          'HighChol': highCholController.text,
          'CholCheck': cholCheckController.text,
          'BMI': bmiController.text,
          'Smoker': smokerController.text,
          'Stroke': strokeController.text,
          'Diabetes': diabetesController.text,
          'PhysActivity': physActivityController.text,
          'Fruits': fruitsController.text,
          'Veggies': veggiesController.text,
          'HvyAlcoholConsump': hvyAlcoholConsumpController.text,
          'AnyHealthcare': anyHealthcareController.text,
          'NoDocbcCost': noDocbcCostController.text,
          'GenHlth': genHlthController.text,
          'MentHlth': mentHlthController.text,
          'PhysHlth': physHlthController.text,
          'DiffWalk': diffWalkController.text,
          'Sex': sexController.text,
          'Age': ageController.text,
          'Education': educationController.text,
          'Income': incomeController.text,
        });
        print('Symptoms saved to Firebase');
      } catch (error) {
        print('Failed to save symptoms to Firebase: $error');
      }
    }


  }
  bool isNumeric(String value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
    return numericRegex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Heart Disease Symptoms Collector Form'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: highBPController,
                      decoration: InputDecoration(
                        labelText: 'High Blood Pressure',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: highCholController,
                      decoration: InputDecoration(
                        labelText: 'High Cholesterol',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: cholCheckController,
                      decoration: InputDecoration(
                        labelText: 'Cholesterol Check',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: bmiController,
                      decoration: InputDecoration(
                        labelText: 'BMI',
                        hintText: 'e.g. 40',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: smokerController,
                      decoration: InputDecoration(
                        labelText: 'Smoker',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: strokeController,
                      decoration: InputDecoration(
                        labelText: 'Stroke',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: diabetesController,
                      decoration: InputDecoration(
                        labelText: 'Diabetes',
                        hintText: "0: No, 1:Type 1 Diabetes, 2:Type 2 Diabetes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: physActivityController,
                      decoration: InputDecoration(
                        labelText: 'Physical Activity',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: fruitsController,
                      decoration: InputDecoration(
                        labelText: 'Fruits',
                        hintText: "0: No, 1:Yes",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: veggiesController,
                      decoration: InputDecoration(
                        labelText: 'Veggies',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: hvyAlcoholConsumpController,
                      decoration: InputDecoration(
                        labelText: 'Heavy Alcohol Consumption',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: anyHealthcareController,
                      decoration: InputDecoration(
                        labelText: 'Any Healthcare issue diagnosed',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: noDocbcCostController,
                      decoration: InputDecoration(
                        labelText: 'Paid high amount for doctor visits',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: genHlthController,
                      decoration: InputDecoration(
                        labelText: 'General Health',
                        hintText: "0: Not Healthy, 1:Healthy",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: mentHlthController,
                      decoration: InputDecoration(
                        labelText: 'Mental Health',
                        hintText: "0: Not Healthy, 1:Healthy",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: physHlthController,
                      decoration: InputDecoration(
                        labelText: 'Physical Health',
                        hintText: "0: Not Healthy, 1:Healthy",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: diffWalkController,
                      decoration: InputDecoration(
                        labelText: 'Difficulty in Walking',
                        hintText: "0: No, 1:Yes",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: sexController,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        hintText: "0: Female, 1: Male",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        hintText: "e.g. 45",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: educationController,
                      decoration: InputDecoration(
                        labelText: 'Education',
                        hintText: "0: Never attended school, 1:KG-6, 2:6-10, 3:10-College",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: incomeController,
                      decoration: InputDecoration(
                        labelText: 'Income (K = 1000)',
                        hintText: "1: >10K, 2:>30K, 3:>60K, 4>100K, 5:>150K, 6:=<150K",
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value';
                        }
                        if (!isNumeric(value)) {
                          return 'Please enter a numeric value';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _predictDisease,
                      child: Text('Submit'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Result: $result',
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        _showPredictionDialog(context);
                      },
                      child: Text('Generate Report'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: HeartSymptomsForm()));
}