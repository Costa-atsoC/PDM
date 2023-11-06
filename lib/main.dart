import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'windowGeneral.dart';
import 'windowRegister.dart';

import 'Management.dart';
import 'windowHome.dart';
import 'Utils.dart';
import 'database_help.dart';


void main() {
  DatabaseHelper.db();
  runApp(const MyApp());
}

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});

  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");
    appManagement.Load();
    return MaterialApp(
      title: 'RideWME',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(appManagement,
          appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Management Ref_Management;

  MyHomePage(this.Ref_Management, this.title);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(Ref_Management);
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    DatabaseHelper.db();
  }

  bool selected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey
  int _counter = 0;
  Management Ref_Management;

  _MyHomePageState(this.Ref_Management);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Widget Create_Button_New_Window_Register() {
    double TAM = double.parse(
        Ref_Management.GetDefinicao("TAMANHO_TEXTO_BTN_NEW_REGISTER", "10"));
    return SelectableButton(
      selected: selected,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return null; // defer to the defaults
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.indigo;
            }
            return null; // defer to the defaults
          },
        ),
      ),
      onPressed: () {
        setState(
          () {
            selected = !selected;
            UtilsFlutter.MSG(Ref_Management.GetDefinicao(
                "TEXT_NEW_WINDOW_REGISTER",
                "Accao-TEXT_NEW_WINDOW_REGISTER ??"));
            NavigateTo_Window_Register(context);
          },
        );
      },
      child: Text(
        Ref_Management.GetDefinicao(
            "TEXT_OF_BUTTON_REGISTER", "TEXT_NEW_WINDOW_REGISTER ??"),
      ),
    );

  }

  /// -----------------------------------
  ///            WINDOW FUNCTIONS
  /// -----------------------------------
  //--------- Janela Register
  Future NavigateTo_Window_Register(context) async {
    windowRegister win = new windowRegister(Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------- Janela Home
  Future Navegar_Janela_Home(context) async {
    windowHome Jan = new windowHome(Ref_Management);
    await Jan.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Jan));
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(140),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/PORSCHE_MAIN.JPEG'),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        labelText: Ref_Management.SETTINGS
                            .Get("JNL_LOGIN_HINT_1", "JNL_LOGIN_HINT_1 ??"),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.password_outlined),
                        labelText: Ref_Management.SETTINGS
                            .Get("JNL_LOGIN_HINT_2", "JNL_LOGIN_HINT_2 ??"),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          UtilsFlutter.MSG('TESTE');
                          Navegar_Janela_Home(context);
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {

                          }
                        },
                        child: Text(Ref_Management.SETTINGS
                            .Get("JNL_LOGIN_BTN_1", "JNL_LOGIN_BTN_1 ??")),
                      ),
                    ),
                    // CriarButton_New_Window_Login(),
                    Create_Button_New_Window_Register(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
