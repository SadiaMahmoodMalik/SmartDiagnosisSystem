import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_time_picker/date_time_picker.dart';

class Doctor {
  late String name;
  late String specialization;
  late String location;
  late String hospital;
  late String availability_hour;
  late String emailAddress;
  late String day;

  Doctor({
    required this.name,
    required this.specialization,
    required this.location,
    required this.hospital,
    required this.availability_hour,
    required this.day,
    required this.emailAddress,
  });

  void deleteDoctor(List<Doctor> doctors) {
    doctors.remove(this);
  }
}

List<Doctor> generateDummyDoctors(int count) {
  List<Doctor> doctors = [];

  final faker = Faker();

  List<String> days = ['Mon', 'Tue', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];
  List<String> specializations = ['Heart Specialist', 'Diabetes Specialist'];
  List<String> locations = ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar'];
  List<String> hospitals = [
    'Aga Khan University Hospital',
    'Lahore General Hospital',
    'Shifa International Hospital',
    'Rawalpindi Medical University',
    'Hayatabad Medical Complex'
  ];

  List<String> pakistaniMuslimFirstNames = [
    'Muhammad',
    'Ali',
    'Ahmed',
    'Hassan',
    'Usman',
    'Ibrahim',
    'Omar',
    'Abdullah',
    'Zainab',
    'Ayesha',
    'Fatima',
    'Khadija',
    'Maryam',
    'Sara',
    'Hafsa',
    'Zahra',
  ];

  List<String> pakistaniMuslimLastNames = [
    'Khan',
    'Ali',
    'Ahmed',
    'Raza',
    'Hussain',
    'Malik',
    'Mahmood',
    'Qureshi',
    'Sheikh',
    'Zaman',
    'Akhtar',
    'Iqbal',
    'Aziz',
    'Siddiqui',
    'Farooq',
    'Rashid',
  ];

  for (int i = 0; i < count; i++) {
    String firstName = pakistaniMuslimFirstNames[i % pakistaniMuslimFirstNames.length];
    String lastName = pakistaniMuslimLastNames[(i + 1) % pakistaniMuslimLastNames.length];
    String name = 'Dr. $firstName $lastName';
    String specialization = specializations[i % specializations.length];
    String location = locations[i % locations.length];
    String hospital = hospitals[i % hospitals.length];
    String day = days[i % days.length];
    String availability_hour = '';
    String emailAddress = '$firstName$lastName@doctor.com';

    Doctor doctor = Doctor(
      name: name,
      specialization: specialization,
      location: location,
      hospital: hospital,
      availability_hour: availability_hour,
      day: day,
      emailAddress: emailAddress,
    );
    doctors.add(doctor);
  }

  return doctors;
}

class DoctorsPage extends StatefulWidget {
  final List<Doctor> doctors;

  DoctorsPage({required this.doctors});

  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final databaseReference = FirebaseDatabase.instance.ref().child('doctors');

  void deleteDoctor(Doctor doctor) {
    setState(() {
      doctor.deleteDoctor(widget.doctors);
    });
  }

  Future<void> createUserWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User created: ${userCredential.user}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveDoctor(Doctor doctor) {
    createUserWithEmail(doctor.emailAddress, 'password'); // Create a user with the doctor's email address and a default password
    RegExp emailPattern = RegExp(r'@doctor\.com$');
    if (emailPattern.hasMatch(doctor.emailAddress)) {
      databaseReference.child(doctor.emailAddress.replaceAll('.', ',')).set({
        'name': doctor.name,
        'specialization': doctor.specialization,
        'location': doctor.location,
        'hospital': doctor.hospital,
        'day': doctor.day,
        'availability_hour': doctor.availability_hour,
        'email_address': doctor.emailAddress,
      });
    }

    setState(() {
      widget.doctors.add(doctor);
    });
  }

  void editDoctor(Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = doctor.name.substring(4); // Remove the 'Dr. ' prefix
        String specialization = doctor.specialization;
        String location = doctor.location;
        String hospital = doctor.hospital;
        String day = doctor.day;
        String availability_hour = doctor.availability_hour;
        String emailAddress = doctor.emailAddress;

        return AlertDialog(
          title: Text('Edit Doctor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextFormField(
                initialValue: specialization,
                decoration: InputDecoration(labelText: 'Specialization'),
                onChanged: (value) {
                  specialization = value;
                },
              ),
              TextFormField(
                initialValue: location,
                decoration: InputDecoration(labelText: 'Location'),
                onChanged: (value) {
                  location = value;
                },
              ),
              TextFormField(
                initialValue: hospital,
                decoration: InputDecoration(labelText: 'Hospital'),
                onChanged: (value) {
                  hospital = value;
                },
              ),
              TextFormField(
                initialValue: day,
                decoration: InputDecoration(labelText: 'Day'),
                onChanged: (value) {
                  day = value;
                },
              ),
              GestureDetector(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((time) {
                    if (time != null) {
                      setState(() {
                        availability_hour = time.format(context); // Format the selected time as per your requirement
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 10.0),
                      Text(
                        availability_hour.isEmpty ? 'Select availability hour' : availability_hour,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              TextFormField(
                initialValue: emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
                onChanged: (value) {
                  emailAddress = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Doctor updatedDoctor = Doctor(
                  name: 'Dr. $name',
                  specialization: specialization,
                  location: location,
                  hospital: hospital,
                  availability_hour: availability_hour,
                  emailAddress: emailAddress,
                  day: day,
                );

                // Update the doctor in the database
                RegExp emailPattern = RegExp(r'@doctor\.com$');
                if (emailPattern.hasMatch(doctor.emailAddress)) {
                  databaseReference.child(
                      doctor.emailAddress.replaceAll('.', ',')).update({
                    'name': updatedDoctor.name,
                    'specialization': updatedDoctor.specialization,
                    'location': updatedDoctor.location,
                    'hospital': updatedDoctor.hospital,
                    'availability_hour': updatedDoctor.availability_hour,
                    'email_address': updatedDoctor.emailAddress,
                    'day': updatedDoctor.day,
                  });


                  setState(() {
                    doctor.name = updatedDoctor.name;
                    doctor.specialization = updatedDoctor.specialization;
                    doctor.location = updatedDoctor.location;
                    doctor.hospital = updatedDoctor.hospital;
                    doctor.availability_hour = updatedDoctor.availability_hour;
                    doctor.emailAddress = updatedDoctor.emailAddress;
                    doctor.day = updatedDoctor.day;
                  });
                }
                Navigator.of(context).pop();
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
        title: Text('Doctors'),
      ),
      body: ListView.builder(
        itemCount: widget.doctors.length,
        itemBuilder: (BuildContext context, int index) {
          Doctor doctor = widget.doctors[index];

          return ListTile(
            title: Text(doctor.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Specialization: ${doctor.specialization}'),
                Text('Location: ${doctor.location}'),
                Text('Hospital: ${doctor.hospital}'),
                Text('Day: ${doctor.day}'),
                Text('Availability Hour: ${doctor.availability_hour}'),
                Text('Email Address: ${doctor.emailAddress}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                editDoctor(doctor);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String name = '';
              String specialization = '';
              String location = '';
              String hospital = '';
              String day = '';
              String availability_hour = '';
              String emailAddress = '';

              return AlertDialog(
                title: Text('Add Doctor'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Name'),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Specialization'),
                      onChanged: (value) {
                        specialization = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Location'),
                      onChanged: (value) {
                        location = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Hospital'),
                      onChanged: (value) {
                        hospital = value;
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((time) {
                          if (time != null) {
                            setState(() {
                              availability_hour = time.format(context); // Format the selected time as per your requirement
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 10.0),
                            Text(
                              availability_hour.isEmpty ? 'Select availability hour' : availability_hour,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Day'),
                      onChanged: (value) {
                        day = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email Address'),
                      onChanged: (value) {
                        emailAddress = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Doctor newDoctor = Doctor(
                        name: 'Dr. $name',
                        specialization: specialization,
                        location: location,
                        hospital: hospital,
                        day: day,
                        availability_hour: availability_hour,
                        emailAddress: emailAddress,
                      );

                      saveDoctor(newDoctor);

                      Navigator.of(context).pop();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  List<Doctor> dummyDoctors = generateDummyDoctors(10);

  runApp(MaterialApp(
    home: DoctorsPage(doctors: dummyDoctors),
  ));
}
