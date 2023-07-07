import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Doctor {
  final String name;
  final String specialization;
  final String location;
  final String hospital;
  final String day;
  final String availability_hour;
  final String email_address;

  Doctor({
    required this.name,
    required this.specialization,
    required this.location,
    required this.hospital,
    required this.day,
    required this.availability_hour,
    required this.email_address,
  });
}

class DoctorListPage extends StatefulWidget {
  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  late User _currentUser;
  List<Doctor> doctors = [];
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.reference().child('doctors');
    fetchDoctors();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _fetchUserData();
  }

  String useremail = '';
  void _fetchUserData() {
    _databaseReference.child(_currentUser.email!.replaceAll('.', ',')).once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> userData = snapshot.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          useremail = userData['email'];
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }



  void fetchDoctors() {
    _databaseReference.once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> values =
        snapshot.snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, values) {
          final doctor = Doctor(
            name: values['name'] ?? '', // Handle null value with empty string
            specialization: values['specialization'] ?? '', // Handle null value with empty string
            location: values['location'] ?? '', // Handle null value with empty string
            hospital: values['hospital'] ?? '', // Handle null value with empty string
            availability_hour: values['availability_hour'] ?? '', // Handle null value with empty string
            email_address: values['email_address'] ?? '', // Handle null value with empty string
            day: values['day'] ?? '', // Handle null value with empty string
          );
          if (doctor.specialization == 'Heart Specialist') {
            setState(() {
              doctors.add(doctor);
            });
          }
        });
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }


  void shareDoctor(Doctor doctor) async {
    String message =
        'Doctor: ${doctor.name}\n\n' +
            'Specialization: ${doctor.specialization}\n' +
            'Location: ${doctor.location}\n' +
            'Hospital: ${doctor.hospital}\n' +
            'Day: ${doctor.day}\n' +
            'Availability Hour: ${doctor.availability_hour}';

    await Share.share(message);
  }

  void contactViaEmail(Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Doctor via Email'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${doctor.email_address}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  void contactDoctor(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Doctor'),
          content: Text('Choose an action'),
          actions: [
            TextButton(
              child: Text('Make Appointment'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                makeAppointment(doctor); // Call makeAppointment() with the selected doctor
              },
            ),
            TextButton(
              child: Text('Contact Doctor via Email'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                contactViaEmail(doctor); // Pass the BuildContext to contactViaEmail
              },
            ),
          ],
        );
      },
    );
  }

  void makeAppointment(Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Make Appointment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Doctor: ${doctor.name}'),
              Text('Availability Hours: ${doctor.availability_hour}'),
              Text('Availability Day: ${doctor.day}'),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Request Appointment'),
              onPressed: () {
                _fetchUserData();
                String doctorEmail = doctor.email_address.replaceAll('.', ',');
                String appointmentContent = 'You request has been sent to ${doctor.name} for appointment at ${doctor.availability_hour} on ${doctor.day}';
                print(appointmentContent);
                DatabaseReference appointmentsRef = FirebaseDatabase.instance.reference().child('doctors');
                DatabaseReference newAppointmentRef = appointmentsRef.child(doctorEmail).child('appointment-requests').push();
                newAppointmentRef.set({
                  '${_currentUser.email!.replaceAll('.', ',')}': "${_currentUser.email} requested an appointment. ",
                  // You can set the approved status here or modify it as per your requirements
                });
                print(newAppointmentRef);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Request sent.'),
                      content: Text(appointmentContent),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the confirmation dialog
                            Navigator.of(context).pop(); // Close the appointment dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: Text('Heart Specialists'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: IconButton(
              icon: Icon(Icons.contacts),
              onPressed: () => contactDoctor(context, doctors[index]),
            ),
            trailing: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => shareDoctor(doctors[index]),
            ),
            title: Text(doctors[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Specialization: ${doctors[index].specialization}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Location: ${doctors[index].location}'),
                Text('Hospital: ${doctors[index].hospital}'),
                Text('Day: ${doctors[index].day}'),
                Text('Availability Hour: ${doctors[index].availability_hour}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DoctorListPage(),
  ));
}
