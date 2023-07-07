import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewComplaintsPage extends StatefulWidget {
  @override
  _ViewComplaintsPageState createState() => _ViewComplaintsPageState();
}

class _ViewComplaintsPageState extends State<ViewComplaintsPage> {
  DatabaseReference? _complaintsRef;
  List<String> _complaintsList = [];

  get useremail => '';

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp();
    _complaintsRef = FirebaseDatabase.instance.ref().child('admin');
    _complaintsRef!.onValue.listen((event) {
      final DataSnapshot snapshot = event.snapshot;
      final Map<dynamic, dynamic>? userData =
      snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
       _complaintsList.clear();
        userData.forEach((userEmail, complaints) {
          if (complaints != null) {
            final Map<dynamic, dynamic> complaintsData =
            complaints as Map<dynamic, dynamic>;
            complaintsData.forEach((complaintKey, complaintValue) {
              _complaintsList.add(complaintValue['complaint'] as String);
            });
            print('complaintsData: $complaintsData');
          }
        });
        setState(() {});
      }
    });
  }

  void sendResponse(String complaint, String response) {
    _complaintsRef!
        .orderByChild('complaint')
        .equalTo(complaint)
        .once()
        .then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        final Map<dynamic, dynamic> complaintsData =
        snapshot.snapshot.value as Map<dynamic, dynamic>;
        final complaintKey = complaintsData.keys.first;

        _complaintsRef!
            .child(complaintKey)
            .child('response')
            .push()
            .set({'response': response}).then((value) {
          print('Response saved successfully!');
        }).catchError((error) {
          print('Failed to save response: $error');
        });
      } else {
        print('No complaints found for the given complaint or the complaints data is empty.');
      }
    }).catchError((error) {
      print('Failed to fetch complaint: $error');
    });
  }



  void showResponseDialog(String complaint) {
    String response = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Respond'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Complaint: $complaint'),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  response = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your response',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform action when Send button is clicked
                sendResponse(complaint, response); // Save the response
                Navigator.of(context).pop();
              },
              child: Text('Send'),
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
        title: Text('View Complaints'),
      ),
      body: ListView.builder(
        itemCount: _complaintsList.length,
        itemBuilder: (context, index) {
          final complaint = _complaintsList[index];

          return Card(
            child: ListTile(
              title: Text(complaint),
              trailing: ElevatedButton(
                onPressed: () {
                  showResponseDialog(complaint);
                },
                child: Text('Respond'),
              ),
            ),
          );
        },
      ),
    );
  }
}
