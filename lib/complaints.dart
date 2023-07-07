import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final _complaintController = TextEditingController();
  User? _currentUser;
  DatabaseReference _complaintsReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> _complaints = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchComplaints();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _fetchComplaints() async {
    final snapshot = await _complaintsReference
        .child('admin')
        .child(_currentUser?.email?.replaceAll('.', ',') ?? '')
        .once();
    final value = snapshot.snapshot.value;

    if (value != null && value is Map) {
      setState(() {
        _complaints = Map<String, dynamic>.from(value)
            .entries
            .map<Map<String, dynamic>>(
                (entry) => {entry.key: entry.value} as Map<String, dynamic>)
            .toList();
      });
    }
  }



  Future<void> _addComplaint(String complaint) async {
    final newComplaintRef = _complaintsReference.child('admin').child(_currentUser?.email?.replaceAll('.', ',') ?? '').push();
    await newComplaintRef.set({'complaint': complaint});
    _complaintController.clear();
    _fetchComplaints();
  }

  Future<void> _deleteComplaint(String complaintKey) async {
    await _complaintsReference.child('admin').child(_currentUser?.email?.replaceAll('.', ',') ?? '').child(complaintKey).remove();
    _fetchComplaints();
  }

  Future<void> _updateComplaint(String complaintKey, String updatedComplaint) async {
    await _complaintsReference.child('admin').child(_currentUser?.email?.replaceAll('.', ',') ?? '').child(complaintKey).update({'complaint': updatedComplaint});
    _fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _complaintController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a complaint';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Complaint',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    _addComplaint(_complaintController.text);
                  }
                },
                child: Text('Submit Complaint'),
              ),
              SizedBox(height: 16.0),
              Text(
                'Your Complaints',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _complaints.length,
                  itemBuilder: (context, index) {
                    final complaintKey = _complaints[index].keys.first;
                    final complaint = _complaints[index][complaintKey]['complaint'];
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteComplaint(complaintKey);
                        },
                      ),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text(complaint, style: TextStyle(
                                fontWeight: FontWeight.bold,

                              ),),
                              Text('Response'),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => _buildEditDialog(complaintKey, complaint),
                            );
                          },
                        ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditDialog(String complaintKey, String currentComplaint) {
    final _editFormKey = GlobalKey<FormState>();
    final _editComplaintController = TextEditingController(text: currentComplaint);

    return AlertDialog(
      title: Text('Edit Complaint'),
      content: Form(
        key: _editFormKey,
        child: TextFormField(
          controller: _editComplaintController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a complaint';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Complaint',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_editFormKey.currentState?.validate() == true) {
              _updateComplaint(complaintKey, _editComplaintController.text);
              Navigator.of(context).pop();
            }
          },
          child: Text('Save'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
