import 'package:flutter/material.dart';
import 'package:ubi/common/Utils.dart';
import 'package:ubi/firestore/user_firestore.dart';
import '../../../firebase_auth_implementation/models/user_model.dart';

class modalUpdateUser extends StatefulWidget {
  final UserModel user;

  const modalUpdateUser({required this.user});

  // Method to show the DetailScreen as a modal bottom sheet
  static void show(BuildContext context, UserModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          // Optional: Make the background transparent
          child: modalUpdateUser(user: user),
        );
      },
    );
  }

  @override
  State<StatefulWidget> createState() => modalUpdateUserState();
}

class modalUpdateUserState extends State<modalUpdateUser> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _fullnameController.text = widget.user.fullName;
    _locationController.text = widget.user.location;
    _usernameController.text = widget.user.username;
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
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
                      controller: _emailController,
                      validator: formValidator,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      validator: formValidator,
                      controller: _fullnameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.drive_file_rename_outline),
                        labelText: "FullName",
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        labelText: "Username",
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.add_location_sharp),
                        labelText: "Location",
                      ),
                      keyboardType: TextInputType.streetAddress,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Update post data

                            UserModel updatedUser = UserModel(
                              uid: widget.user.uid,
                              username: _usernameController.text,
                              email: _emailController.text,
                              fullName: _fullnameController.text,
                              registerDate: widget.user.registerDate,
                              lastChangedDate: Utils.currentTimeUser(),
                              location: _locationController.text,
                              image: widget.user.image,
                              online: "1",
                              lastLogInDate: widget.user.lastLogInDate,
                              lastSignOutDate: widget.user.lastSignOutDate,
                            );
                            UserFirestore().updateUserData(updatedUser);

                            // IMPLEMENTAR METODO PARA GUARDAR NAS SHARED PREFERNCES TUDO ISTO (O QUE FOR RELEVANTE ALIAS)

                            Navigator.pop(context); // Close the modal

                          setState(() {

                          });



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
