import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../database_help.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowUserProfile extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowUserProfile(this.Ref_Management) {
    windowTitle = "General Window";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowUserProfile(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowUserProfile extends State<windowUserProfile> {
  final windowUserProfile Ref_Window;
  String className = "";

  //--------------
  State_windowUserProfile(this.Ref_Window) : super() {
    className = "State_windowGeneral";
    Utils.MSG_Debug("$className: createState");
  }

  //--------------
  @override
  void dispose() {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$className:dispose");
  }

  //--------------
  @override
  void deactivate() {
    Utils.MSG_Debug("$className:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("$className: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$className: initState");
    super.initState();
    _refreshData();
  }

  void NavigateTo_New_Window(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                windowUserProfile(Ref_Window.Ref_Management)));
  }

  //--- database constants
  // All data
  List<Map<String, dynamic>> myData = [];
  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  //------ end of database constants

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  //------ Start of Database
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void showMyForm(int? id) async {
    // id == null -> create new item
    // id != null -> update an existing item
    if (id != null) {
      final existingData = myData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['description'];
      _dateController.text = existingData['date'];
    } else {
      _titleController.text = "";
      _descriptionController.text = "";
      _dateController.text = '';
    }

    showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 69, 78, 89),
        context: context,
        elevation: 5,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              // prevent the soft keyboard from covering the text fields
              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
            ),
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
                      icon: Icon(Icons.title), //icon of text field
                      iconColor: Colors.white,
                      labelText: "Title", //label text of field
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: formValidator,
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.description), //icon of text field
                      iconColor: Colors.white,
                      labelText: "Description", //label text of field
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: formValidator,
                    controller: _dateController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      iconColor: Colors.white,
                      labelText: "Enter Date", //label text of field
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          _dateController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (id == null) {
                              await addItem();
                            }

                            if (id != null) {
                              await updateItem(id);
                            }

                            // Clear the text fields
                            setState(() {
                              _titleController.text = '';
                              _descriptionController.text = '';
                              _dateController.text = '';
                            });

                            // Close the bottom sheet
                            Navigator.pop(context);
                            //_refreshData();
                          }
                          // Save new data
                        },
                        child: Text(id == null ? 'Add' : 'Update'),
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

// Insert a new data to the database
  Future<void> addItem() async {
    await DatabaseHelper.createItem(1, _titleController.text,
        _descriptionController.text, _dateController.text);
    _refreshData();
  }

  // Update an existing data
  Future<void> updateItem(int id) async {
    await DatabaseHelper.updateItem(id, _titleController.text,
        _descriptionController.text, _dateController.text);
    _refreshData();
  }

  // Delete an item
  void deleteItem(int id) async {
    await DatabaseHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'), backgroundColor: Colors.green));
    _refreshData();
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(Ref_Window.Ref_Management.SETTINGS
              .Get("WND_PROFILE_TITLE_1", "User Profile")),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                // trocar isto por margin, mas por enquanto fica assim
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(140),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 120,
                  backgroundImage: AssetImage("assets/PORSCHE_MAIN.JPEG"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Location',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                      ),
                    ),
                  ]),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '@username',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 60,
              ),
              Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : myData.isEmpty
                        ? const Center(child: Text("No Data Available!!!"))
                        : ListView.builder(
                            itemCount: myData.length,
                            itemBuilder: (context, index) => Card(
                              color: index % 2 == 0
                                  ? Colors.blue
                                  : Colors.blue[200],
                              margin: const EdgeInsets.all(15),
                              child: ListTile(
                                  title: Text(myData[index]['title']),
                                  subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(myData[index]['date']),
                                        Text(myData[index]['description']),
                                      ]),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              showMyForm(myData[index]['id']),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              deleteItem(myData[index]['id']),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
//--------------
//--------------
//--------------
}
