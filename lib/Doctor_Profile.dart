import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfilePage extends StatefulWidget {
  final String doctorEmail;

  DoctorProfilePage({required this.doctorEmail});

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _availabilityController = TextEditingController();

  String zoomMeetingUrl = "https://zoom.us/j/1234567890";

  void openZoomMeeting() async {
    if (await canLaunch(zoomMeetingUrl)) {
      await launch(zoomMeetingUrl);
    } else {
      throw 'Could not launch $zoomMeetingUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Edit Doctor Details'),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _hospitalController,
                              decoration: InputDecoration(
                                labelText: 'Hospital',
                              ),

                            ),
                            TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                              ),

                            ),
                            TextFormField(
                              controller: _availabilityController,
                              decoration: InputDecoration(
                                labelText: 'Availability Hours',
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveDoctorDetails();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchDoctorDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading doctor details: ${snapshot.error}'),
            );
          } else {
            final doctorDetails = snapshot.data as Map<dynamic, dynamic>;
            final availabilityHours = doctorDetails['availability_hour'];
            final location = doctorDetails['location'];
            final hospital = doctorDetails['hospital'];
            final name = doctorDetails['name'];
            final emailAddress = doctorDetails['email_address'];
            final specialization = doctorDetails['specialization'];
            Map<dynamic,
                dynamic> appointments = doctorDetails['appointment-requests'];

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: $name'),
                    Text('Email: $emailAddress'),
                    Text('Specialization: $specialization'),
                    Text('Hospital: $hospital'),
                    Text('Location: $location'),
                    Text('Availability Hours: $availabilityHours'),
                    SizedBox(height: 50,),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Appointment Requests'),
                              content: Column(
                                children: appointments.entries.map((entry) {
                                  final userEmail = entry.key.toString().split(
                                      ':')[0].trim();
                                  print('entry key: $userEmail');
                                  final appointmentRequest = entry.value;

                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    margin: EdgeInsets.only(bottom: 8.0),
                                    padding: EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Text(
                                          '$userEmail: $appointmentRequest'),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Appointment Request'),
                                              content: Text(
                                                  'User: $userEmail\nAppointment: $appointmentRequest'),
                                              actions: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Approve appointment
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Appointment Approved'),
                                                          content: Text(
                                                              'Approved message has been sent.'),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                final userRef = FirebaseDatabase
                                                                    .instance
                                                                    .ref()
                                                                    .child(
                                                                    'user-signup/$userEmail');
                                                                await userRef
                                                                    .child(
                                                                    'messages')
                                                                    .child(
                                                                    widget
                                                                        .doctorEmail
                                                                        .replaceAll(
                                                                        '.',
                                                                        ','))
                                                                    .set({
                                                                  'message': 'Your appointment with Dr. $name has been approved.',
                                                                });
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Approve'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Disapprove appointment
                                                    Navigator.of(context).pop();
                                                    showDialog(
                                                      context: context,
                                                      builder: (
                                                          BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Appointment Disapproved'),
                                                          content: Text(
                                                              'Disapproved message has been sent.'),
                                                          actions: [
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                final userRef = FirebaseDatabase
                                                                    .instance
                                                                    .ref()
                                                                    .child(
                                                                    'user-signup/$userEmail');
                                                                await userRef
                                                                    .child(
                                                                    'messages')
                                                                    .child(
                                                                    widget
                                                                        .doctorEmail
                                                                        .replaceAll(
                                                                        '.',
                                                                        ','))
                                                                    .set({
                                                                  'message': 'Your appointment with Dr. $name has been disapproved.',
                                                                });
                                                                Navigator.of(
                                                                    context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('Disapprove'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text("View Appointments"),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<dynamic, dynamic>> fetchDoctorDetails() async {
    final modifiedEmailAddress = widget.doctorEmail.replaceAll('.', ',');
    final databaseRef = FirebaseDatabase.instance.ref().child(
        'doctors/$modifiedEmailAddress');
    final snapshot = await databaseRef.once();

    if (snapshot.snapshot.value != null) {
      final Map<dynamic, dynamic> doctorDetails = snapshot.snapshot
          .value as Map<dynamic, dynamic>;
      return doctorDetails;
    } else {
      throw Exception('Doctor not found');
    }
  }

  void saveDoctorDetails() {
    final modifiedEmailAddress = widget.doctorEmail.replaceAll('.', ',');
    final databaseRef = FirebaseDatabase.instance.ref().child(
        'doctors/$modifiedEmailAddress');

    databaseRef
        .update({
      'hospital': _hospitalController.text,
      'location': _locationController.text,
      'availability_hour': _availabilityController.text,
    })
        .then((value) {
      // Fetch and update the doctor details after successful update
      fetchDoctorDetails().then((updatedDoctorDetails) {
        setState(() {
          // Update the doctor details
          final availabilityHours = updatedDoctorDetails['availability_hour'];
          final location = updatedDoctorDetails['location'];
          final hospital = updatedDoctorDetails['hospital'];
          final name = updatedDoctorDetails['name'];
          final specialization = updatedDoctorDetails['specialization'];

          // Update the text fields
          _availabilityController.text = availabilityHours;
          _locationController.text = location;
          _hospitalController.text = hospital;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Doctor details updated successfully'),
          ),
        );
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update doctor details: $error'),
        ),
      );
    });
  }
}
