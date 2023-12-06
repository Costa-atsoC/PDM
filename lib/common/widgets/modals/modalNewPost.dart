import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import 'package:ubi/windowHome.dart';
import 'package:uuid/uuid.dart';
import '../../../firebase_auth_implementation/models/post_model.dart';
import '../../../firestore/post_firestore.dart';
import '../../../firestore/user_firestore.dart';
import '../../Utils.dart';

class ModalNewPost extends StatefulWidget {

  const ModalNewPost();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ModalNewPost();
      },
    );
  }

  @override
  _ModalNewPostState createState() => _ModalNewPostState();
}

class _ModalNewPostState extends State<ModalNewPost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _totalSeatsController = TextEditingController();
  final TextEditingController _freeSeatsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startLocationController = TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserFirestore userFirestore = UserFirestore();
    PostFirestore postFirestore = PostFirestore();

    return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: formValidator,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        labelText: "Title",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: formValidator,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        labelText: "Description",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.location_on),
                        labelText: "Location",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _startLocationController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.start),
                        labelText: "Start Location",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _endLocationController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.tab_sharp),
                        labelText: "End Location",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: formValidator,
                      controller: _dateController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
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

                        if (pickedDate != null) {
                          String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);

                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _totalSeatsController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.confirmation_number),
                        labelText: "Total Seats",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _freeSeatsController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.event_seat),
                        labelText: "Free Seats",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Update post data
                          if (int.parse(_totalSeatsController.text) <
                              int.parse(_freeSeatsController.text)) {
                            _freeSeatsController.text = "0";
                          } else {
                            String currentUID = FirebaseAuth.instance.currentUser!.uid;
                            userFirestore.getUserData(currentUID).then((UserModel? currentUser) {
                              // Use currentUser as needed
                              if (currentUser != null) {
                                PostModel newPost = PostModel(
                                  uid: FirebaseAuth.instance.currentUser!.uid,
                                  userFullName: currentUser.fullName,
                                  username: currentUser.username,
                                  pid: const Uuid().v4(),
                                  likes: '0',
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

                                PostFirestore().savePostData(newPost, currentUID);
                                Navigator.pop(context); // Close the modal
                              } else {
                                print("User data not found");
                              }
                            }).catchError((e) {
                              // Handle any potential errors
                              print("Error retrieving user data: $e");
                            });


                          }

                          // Update the post using your firestore method
                        }
                      },
                      child: const Text('Add Post'),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                        child: const Text('Cancel')
                    ),
                  ],
                ),
              )),
        ));
  }
}

String? formValidator(String? value) {
  if (value!.isEmpty) return 'Field is Required';
  return null;
}
