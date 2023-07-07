import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartdiagnosissystem/home_page.dart';
import 'package:smartdiagnosissystem/login.dart';
import 'package:smartdiagnosissystem/intro_page1.dart';
import 'package:smartdiagnosissystem/firebase_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _birthController = TextEditingController();
  String _selectedGender = "male";

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 32),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Your name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                      return "Name should only contain alphabets";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Your email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Create password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please create a password";
                    } else if (value.length < 8) {
                      return "Password should be at least 8 characters long";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _retypePasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Retype password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please retype your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField(
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _selectedGender = value;
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem(child: Text("Male"), value: "male"),
                    DropdownMenuItem(child: Text("Female"), value: "female"),
                    DropdownMenuItem(child: Text("Other"), value: "other"),
                  ],
                  decoration: InputDecoration(
                    labelText: "Select gender",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please select your gender";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _birthController,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _birthController.text = picked.toString().substring(0, 10);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Birth date",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select your birth date";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Validate the form fields
                        String? userId = await _firebaseService.signUp(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (userId != null) {
                          // User sign-up successful
                           _firebaseService.saveUserInfo(
                            userId,
                            _nameController.text,
                            _emailController.text,
                             _selectedGender,
                             _birthController.text,
                          );
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LogInPage()),
                          );
                        } else {
                          // User already exists or sign-up failed
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User already exists or sign-up failed.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text("Create account"),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: Text(
                        "Sign in now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
