import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smartdiagnosissystem/complaints.dart';
import 'package:smartdiagnosissystem/diabetes_doctor.dart';
import 'package:smartdiagnosissystem/heart_doctors.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _currentUser;
  DatabaseReference _userRef = FirebaseDatabase.instance.ref().child('user-signup');

  String? name;
  String email = '';
  String? birthDate;
  String? gender;

  String? highBP;
  String? highChol;
  String? cholCheck;
  String? bmi;
  String? smoker;
  String? stroke;
  String? diabetes;
  String? physActivity;
  String? fruits;
  String? veggies;
  String? hvyAlcoholConsump;
  String? anyHealthcare;
  String? noDocbcCost;
  String? genHlth;
  String? mentHlth;
  String? physHlth;
  String? diffWalk;
  String? sex;
  String? education;
  String? income;
  String? age;
  String? predictedDisease;
  Map? messages;
  String? docName;
  String? messageContent;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  void _fetchUserData() {
    _userRef.child(_currentUser.email!.replaceAll('.', ',')).once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          name = userData['name'];
          email = _currentUser.email!;
          birthDate = userData['date of birth'];
          gender = userData['gender'];
          print("$name $email $birthDate $gender");

          Map<dynamic, dynamic>? messaged = userData['messages'];
          messages = messaged;

          Map<dynamic, dynamic>? predictedDiseaseData = userData['predicted-disease'];
          predictedDisease = predictedDiseaseData?['Predicted Disease'];

          Map<dynamic, dynamic> symptoms = userData['symptoms'];
          highBP = symptoms['HighBP'];
          highChol = symptoms['HighChol'];
          cholCheck = symptoms['CholCheck'];
          bmi = symptoms['BMI'];
          smoker = symptoms['Smoker'];
          stroke = symptoms['Stroke'];
          diabetes = symptoms['Diabetes'];
          physActivity = symptoms['PhysActivity'];
          fruits = symptoms['Fruits'];
          veggies = symptoms['Veggies'];
          hvyAlcoholConsump = symptoms['HvyAlcoholConsump'];
          anyHealthcare = symptoms['AnyHealthcare'];
          noDocbcCost = symptoms['NoDocbcCost'];
          genHlth = symptoms['GenHlth'];
          mentHlth = symptoms['MentHlth'];
          physHlth = symptoms['PhysHlth'];
          diffWalk = symptoms['DiffWalk'];
          sex = symptoms['Sex'];
          education = symptoms['Education'];
          income = symptoms['Income'];
          age = symptoms['Age'];
          print("user info fetched");
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  void _updateUserData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? newName = name;
        String? newBirthDate = birthDate;
        String? newGender = gender;

        return AlertDialog(
          title: Text('Edit User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newBirthDate = value;
                },
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                ),
              ),
              TextField(
                onChanged: (value) {
                  newGender = value;
                },
                decoration: InputDecoration(
                  labelText: 'Gender',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (newName!.isNotEmpty && newGender!.isNotEmpty && newBirthDate!.isNotEmpty) {
                  name = newName;
                  gender = newGender;
                  birthDate = newBirthDate;

                  _userRef.child(_currentUser.email!.replaceAll('.', ',')).update({
                    'name': newName,
                    'gender': newGender,
                    'date of birth': newBirthDate,
                  });

                  setState(() {
                    name = newName;
                    birthDate = newBirthDate;
                    gender = newGender;
                  });

                  Navigator.of(context).pop(); // Close the dialog
                  _fetchUserData(); // Fetch the updated data
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintPage()),
                );
              },
              child: Text("Feedback"),
            ),
            Text('Name: ${name ?? 'Loading...'}'),
            Text('Email: ${email ?? 'Loading...'}'),
            Text('Birth Date: ${birthDate ?? 'Loading...'}'),
            Text('Gender: ${gender ?? 'Loading...'}'),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Added Symptoms'),
                      content: Column(
                        children: [
                          Text('High Blood Pressure: ${highBP ?? 'Loading...'}'),
                          Text('High Cholesterol: $highChol'),
                          Text('Cholesterol Check: $cholCheck'),
                          Text('BMI: $bmi'),
                          Text('Smoker: $smoker'),
                          Text('Stroke: $stroke'),
                          Text('Diabetes: $diabetes'),
                          Text('Physical Activity: $physActivity'),
                          Text('Fruits: $fruits'),
                          Text('Vegetables: $veggies'),
                          Text('Heavy Alcohol Consumption: $hvyAlcoholConsump'),
                          Text('Any Healthcare: $anyHealthcare'),
                          Text('No Doctor because of Cost: $noDocbcCost'),
                          Text('General Health: $genHlth'),
                          Text('Mental Health: $mentHlth'),
                          Text('Physical Health: $physHlth'),
                          Text('Difficulty Walking: $diffWalk'),
                          Text('Sex: $sex'),
                          Text('Education: $education'),
                          Text('Income: $income'),
                          Text('Age: $age'),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Predicted Disease'),
                                    content: Column(
                                      children: [
                                        Text('Predicted Disease: ${predictedDisease ?? 'Loading...'}'),
                                        if (predictedDisease == 'Diabetes')
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => DiabetesDoctorListPage()),
                                              );
                                            },
                                            child: Text('Recommend Diabetes Specialists'),
                                          ),
                                        if (predictedDisease == 'Heart Disease')
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => DoctorListPage()),
                                              );
                                            },
                                            child: Text('Recommend Heart Specialists'),
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); // Close the dialog
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('View Predicted Disease'),
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('View Added Symptoms'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Requests Status'),
                      content: Container(
                        height: 200,
                        width: double.maxFinite, // Ensure the ListView takes up the full width
                        child: ListView.builder(
                          itemCount: messages!.length,
                          itemBuilder: (context, index) {
                            dynamic email = messages!.keys.elementAt(index);
                            dynamic messageData = messages![email];
                            String messageContent = messageData['message'];

                            return Container(
                                margin: EdgeInsets.only(bottom: 10), // Margin between each item
                            padding: EdgeInsets.all(10), // Padding around the content
                            decoration: BoxDecoration(
                            color: Colors.grey[200], // Background color for each box
                            border: Border.all(color: Colors.grey), // Border color and thickness
                            borderRadius: BorderRadius.circular(8), // Border radius
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10,),
                                  Text(
                                    email.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Message: $messageContent',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("View Appointment Requests Status"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _updateUserData();
          print('Floating action button pressed');
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
