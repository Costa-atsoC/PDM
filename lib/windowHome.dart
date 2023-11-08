import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ubi/windowSettings.dart';
import 'database_help.dart';
import 'windowListView.dart';
import 'windowListViewLinks.dart';
import 'windowNews.dart';
import 'windowUserProfile.dart';
import 'windowSearch.dart';
import 'package:intl/intl.dart';

import 'Management.dart';
import 'Utils.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowHome extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  int? ACCESS_WINDOW_HOME;

  //--------------
  windowHome(this.Ref_Management) {
    windowTitle = "Home";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
    ACCESS_WINDOW_HOME = await Ref_Management.Get_SharedPreferences_INT(
        "JANELA_HOME_NUMERO_ACESSOS");
    Ref_Management.Save_Shared_Preferences_INT(
        "JANELA_HOME_NUMERO_ACESSOS", ACCESS_WINDOW_HOME! + 1);
  }

  int? Get_ACESSO_JANELA_HOME() {
    return ACCESS_WINDOW_HOME;
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowHome(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowHome extends State<windowHome> {
  final windowHome Ref_Window;
  String className = "";

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

  //--------------
  State_windowHome(this.Ref_Window) : super() {
    className = "State_windowHome";
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
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
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
                        labelText: "Title" //label text of field
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
                        labelText: "Description" //label text of field
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
                        labelText: "Enter Date" //label text of field
                    ),
                    readOnly: true,  //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)
                      );

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          _dateController.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
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

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
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

  //------ END OF DATABASE

  bool _showFab = true;
  bool _showNotch = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  void _onShowNotchChanged(bool value) {
    setState(() {
      _showNotch = value;
    });
  }

  void _onShowFabChanged(bool value) {
    setState(() {
      _showFab = value;
    });
  }

  void _onFabLocationChanged(FloatingActionButtonLocation? value) {
    setState(() {
      _fabLocation = value ?? FloatingActionButtonLocation.endDocked;
    });
  }

  void Navegar_Nova_Janela(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => windowHome(Ref_Window.Ref_Management)));
  }

  Future NavigateTo_Window_News(context) async {
    windowNews win = new windowNews(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_User_Profile(context) async {
    windowUserProfile win = new windowUserProfile(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_Search(context) async {
    windowSearch win = new windowSearch(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_Settings(context) async {
    windowSettings win = new windowSettings(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  GetID() async {
    final String userID;
    userID = (await Ref_Window.Ref_Management.ACCESS_NUMBER) as String;
    return userID;
  }

  //-------------

  Widget CriarButton_Shared_Preferences() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text(
        Ref_Window.Ref_Management.GetDefinicao(
            "TITULO_BTN_SHARED_PREFERENCE", "SHARED_PREFERENCE ??"),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        UtilsFlutter.MSG(Ref_Window.Ref_Management.GetDefinicao(
            "TITULO_BTN_SHARED_PREFERENCE", "Accao-BTN_SHARED_PREFERENCE ??"));

        int CLICKS_SP =
        await Ref_Window.Ref_Management.Get_SharedPreferences_INT(
            "CLICKS_SP") as int;
        UtilsFlutter.MSG("CLICKS_SP = $CLICKS_SP");
        Ref_Window.Ref_Management.Save_Shared_Preferences_INT(
            "CLICKS_SP", CLICKS_SP + 1);
      },
    );
  }


  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");

    return MaterialApp(
      home: Scaffold(
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/cover.jpg'))),
                  child: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_DRAWER_TITLE_1", "TEST"), // nao esquecer de adicionar isto ao Management
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.input),
                  title: Text('Welcome'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('Profile'),
                  onTap: () => {NavigateTo_Window_User_Profile(context)},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  onTap: () => {NavigateTo_Window_Settings(context)},
                ),
                ListTile(
                  leading: Icon(Icons.border_color),
                  title: Text('Feedback'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
              ],
            ),
          ),
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(Ref_Window.Ref_Management.SETTINGS
                .Get("JNL_HOME_TITLE_1", "Home Page 1")),
          ),
          body: Container(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : myData.isEmpty
                ? const Center(child: Text("No Data Available!!!"))
                : ListView.builder(
              itemCount: myData.length,
              itemBuilder: (context, index) => Card(
                color:
                index % 2 == 0 ? Colors.blue : Colors.blue[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(myData[index]['title']),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
          floatingActionButton: _showFab
              ? FloatingActionButton(
            onPressed: () => showMyForm(null),
            tooltip: 'Create',
            child: const Icon(Icons.add),
          )
              : null,
          floatingActionButtonLocation: _fabLocation,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Colors.blue,
            child: IconTheme(
              data:
              IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      NavigateTo_Window_Search(context);
                    },
                  ),
                  IconButton(
                    tooltip: 'Favorite',
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )),
    );
  }
}