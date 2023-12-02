import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ubi/windowHome.dart';
import '../../../firebase_auth_implementation/models/post_model.dart';
import '../../../firestore/post_firestore.dart';
import '../../../firestore/user_firestore.dart';
import '../../Utils.dart';

class ModalUpdatePost extends StatefulWidget {
  final PostModel post;

  const ModalUpdatePost({required this.post});

  static void show(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ModalUpdatePost(post: post);
      },
    );
  }

  @override
  _ModalUpdatePostState createState() => _ModalUpdatePostState();
}

class _ModalUpdatePostState extends State<ModalUpdatePost> {
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
    _titleController.text = widget.post.title;
    _descriptionController.text = widget.post.description;
    _dateController.text = widget.post.date;
    _totalSeatsController.text = widget.post.totalSeats;
    _freeSeatsController.text = widget.post.freeSeats;
    _locationController.text = widget.post.location;
    _startLocationController.text = widget.post.startLocation;
    _endLocationController.text = widget.post.endLocation;
    //registerDate: widget.post.registerDate;
  }

  @override
  Widget build(BuildContext context) {
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
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _startLocationController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.start),
                    labelText: "Start Location",
                  ),
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _endLocationController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.tab_sharp),
                    labelText: "End Location",
                  ),
                  keyboardType: TextInputType.streetAddress,
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
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Update post data
                      if (int.parse(_totalSeatsController.text) <
                          int.parse(_freeSeatsController.text)) {
                        _freeSeatsController.text = "0";
                      } else {
                        PostModel updatedPost = PostModel(
                          uid: widget.post.uid,
                          pid: widget.post.pid,
                          likes: widget.post.likes,
                          title: _titleController.text,
                          description: _descriptionController.text,
                          date: _dateController.text,
                          totalSeats: _totalSeatsController.text,
                          freeSeats: _freeSeatsController.text,
                          location: _locationController.text,
                          startLocation: _startLocationController.text,
                          endLocation: _endLocationController.text,
                          registerDate: widget.post.registerDate,
                          lastChangedDate: Utils.currentTime(),
                        );
                        PostFirestore().updatePostData(updatedPost);

                        Navigator.pop(context); // Close the modal

                      }

                      // Update the post using your firestore method
                    }
                  },
                  child: const Text('Save'),
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
