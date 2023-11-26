import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../Management.dart';
import '../Utils.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../firestore/post_firestore.dart';

class PostForm extends StatefulWidget {
  final Management Ref_Management;

  PostForm(this.Ref_Management);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _totalSeatsController = TextEditingController();
  final TextEditingController _freeSeatsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _registerDateController = TextEditingController();
  final TextEditingController _lastChangedDateController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Form'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: formValidator,
                  decoration: InputDecoration(
                    icon: Icon(Icons.title),
                    iconColor: Colors.blue,
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: formValidator,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.description),
                    iconColor: Colors.blue,
                    labelText: "Description",
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.confirmation_number),
                    iconColor: Colors.blue,
                    labelText: "Total Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _startLocationController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.confirmation_number),
                    iconColor: Colors.blue,
                    labelText: "Total Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endLocationController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.confirmation_number),
                    iconColor: Colors.blue,
                    labelText: "Total Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: formValidator,
                  controller: _dateController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    iconColor: Colors.blue,
                    labelText: "Enter Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate!);

                    setState(() {
                      _dateController.text = formattedDate;
                    });
                                    },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _totalSeatsController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.confirmation_number),
                    iconColor: Colors.blue,
                    labelText: "Total Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _freeSeatsController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.event_seat),
                    iconColor: Colors.blue,
                    labelText: "Free Seats",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      PostModel post = PostModel(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        pid: const Uuid().v4(),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        date: _dateController.text,
                        totalSeats: _totalSeatsController.text,
                        freeSeats: _freeSeatsController.text,
                        location: _locationController.text,
                        startLocation: _startLocationController.text,
                        endLocation: _endLocationController.text,
                        registerDate: Utils.currentTime(),
                        lastChangedDate: Utils.currentTime(),
                      );

                      String? uid = FirebaseAuth.instance.currentUser
                          ?.uid; // may fix the problem of creating the post and then it appears with another user UID

                      await PostFirestore().savePostData(post, uid!);

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }
}
