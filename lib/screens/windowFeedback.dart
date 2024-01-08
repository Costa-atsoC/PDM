import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ubi/common/appTheme.dart';

import '../common/Management.dart';
import '../common/theme_provider.dart';

class windowFeedback extends StatefulWidget {
  final Management Ref_Management;

  windowFeedback(this.Ref_Management);

  //--------------
  Future<void> Load() async {
    //Utils.MSG_Debug(windowTitle + ":Load");
    /*
    ACCESS_WINDOW_PROFILE = await Ref_Management.Get_SharedPreferences_INT(
        "WND_PROFILE_ACCESS_NUMBER");
    Ref_Management.Save_Shared_Preferences_INT(
        "WND_PROFILE_ACCESS_NUMBER", ACCESS_WINDOW_PROFILE! + 1);
     */
  }

  @override
  _windowFeedbackState createState() => _windowFeedbackState();
}

class _windowFeedbackState extends State<windowFeedback> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int _currentIndex = 0; // Índice inicial para a seção de Registro

  String selectedFeedbackType = '';

  Widget _buildReportProblemSection() {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ..._buildRadioItems([
              "Login trouble",
              "Phone number related",
              "Personal profile",
              "Post Interaction/Viewing",
              "Suggestions",
              "Other (Specify)", // Opção "Outros"
            ]),
            SizedBox(height: 20.0),
            // Adiciona espaçamento após os itens do radio
            buildFeedbackForm(),
            SizedBox(height: 10.0),
            // Adiciona espaçamento após o formulário de feedback
            buildNumberField(),
            SizedBox(height: 20.0),
            // Adiciona espaçamento antes do botão SUBMIT
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10.0),
                    ),
                    child: Text(
                      "SUBMIT",
                      style: Theme.of(context).textTheme.titleLarge
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRadioItems(List<String> options) {
    return options.map((option) => buildRadioItem(option)).toList();
  }

  Widget buildRadioItem(String title) {
    return RadioListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      value: title,
      groupValue: selectedFeedbackType,
      onChanged: (value) {
        setState(() {
          selectedFeedbackType = value as String;
        });
      },
    );
  }

  Widget buildNumberField() {
    return TextField(
      style: TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(0.0),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: Color(0xffc5c5c5)),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Text(
                    "+351",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffc5c5c5),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.cyan),
                  SizedBox(width: 10.0),
                ],
              ),
            ),
            SizedBox(width: 10.0),
          ],
        ),
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Color(0xffc5c5c5),
        ),
        hintText: "Phone Number",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildFeedbackForm() {
    return Container(
      height: 200.0,
      child: Stack(
        children: <Widget>[
          TextField(
            maxLines: 10,
            decoration: InputDecoration(
              hintText: "Please briefly describe the issue",
              hintStyle: TextStyle(
                fontSize: 13.0,
                color: Color(0xcffc5c5c5),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xcffc5c5c5)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1.0,
                    color: Color(0xffa6a6a6),
                  ),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffe5e5e5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Color(0xffa5a5a5),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    "Upload screenshot (optional)",
                    style: TextStyle(
                      color: Color(0xffc5c5c5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCheckItem(title) {
    return Padding(
        padding: EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.check_circle, color: Colors.blue),
            SizedBox(width: 10.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            )
          ],
        ));
  }

  Widget _buildRatingSection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Avalie a sua experiência com a Aplicação",
            style: TextStyle(fontSize: 20),
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 0.5,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: provider.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("FeedBack", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
            ),
            body: (_currentIndex == 0
                ? _buildReportProblemSection()
                : _buildRatingSection()),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.report),
                  label: 'Reportar Problema',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: 'Avaliação',
                ),
              ],
            ),
          ));
    });
  }
}
