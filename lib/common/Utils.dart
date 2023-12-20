import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'Management.dart';

class Utils {
  //--------- Uteis.Factorial(12);
  static int Factorial(int N) {
    if (N == 0) return 1;
    return N * Factorial(N - 1);
  }

  //--------------------------------------
  static void MSG_Debug(String s) {
    print("DEBUG:" + s);
  }

  //--------------------------------------
  static int Aleatorio(int min, int max) {
    Random rng = new Random();
    return min + rng.nextInt(max - min + 1);
  }

  //--------------------------------------
  static String CriarEspacos(int N, String car) {
    String str = "";
    for (int i = 0; i < N; i++) str += car;
    return str;
  }

  static String currentTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(now);
    return formattedDate;
  }


  //For the creation of the user we need different date format
  static String currentTimeUser() {
    DateTime now = DateTime.now();

    String formattedDate = '${now.year}-${now.month}-${now.day}';

    return formattedDate;
  }

  static String formatTimeDifference(String postDate) {
    // Update the format pattern to match the input date string
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');

    DateTime postDateTime = inputFormat.parse(postDate);

    DateTime now = DateTime.now();
    Duration difference = now.difference(postDateTime);

    if (difference.inDays > 0) {
      Utils.MSG_Debug("${difference.inDays}");
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inMinutes >= 60) {
      int hours = (difference.inMinutes / 60).floor();
      Utils.MSG_Debug("$hours hours");
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      Utils.MSG_Debug("${difference.inMinutes}");
      if(difference.inMinutes < 1){
        return '<1 minute ago';
      }
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
  }



//--------------------------------------
//--------------------------------------
//--------------------------------------
//--------------------------------------
}

class UtilsFlutter {
  static Future<void> Dialogo_1(BuildContext context, String Titulo,
      String Texto1, String Texto2, String Texto3, String texto_botao) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Texto1),
                Text(Texto2),
                Text(Texto3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(texto_botao),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //---------
  static Future<void> Dialogo_2(
      BuildContext context,
      String Titulo,
      String icon,
      String Texto1,
      String Texto2,
      String Texto3,
      String texto_botao) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Titulo),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(Texto1),
                Text(Texto2),
                Text(Texto3),
                CircleAvatar(
                  backgroundImage: NetworkImage(icon),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(texto_botao),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //---------
  // http://www.macoratti.net/19/09/flut_circimg2.htm
  // http://www.macoratti.net/Imagens/pessoas/mac.jpg
  static Widget circleImage_url(double lar, double alt, String url) {
    return Center(
      child: Container(
        width: lar,
        height: alt,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(url))),
      ),
    );
  }


//---------
  static void EnviarSMS(String message, List<String> recipents) async {
    /*
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    */
  }

//---------
  /*
  static Future<void> EnviarSMS_2(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  */
//---------
  static Future<Null> sendSms() async {
    print("SendSMS");
    try {
      const platform = const MethodChannel('sendSms');
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": "+965656293",
        "msg": "Hello! I'm sent programatically."
      }); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

//---------
  static void MSG(String txt) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        //timeInSecForIos: 1
        );
  }

//---------
  Future<bool?> onBackPressed(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("NO"),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("YES"),
          ),
        ],
      ),
    );
  }

  // Ver: http://www.macoratti.net/19/10/flut_codeotm1.htm
  Widget textFieldGenerico(String label, String hint,
      {bool obscure = false, controller, validacao}) {
    return TextFormField(
        controller: controller,
        validator: validacao,
        keyboardType: TextInputType.text,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: label,
            labelStyle: const TextStyle(fontSize: 20.0, color: Colors.black),
            hintText: hint));
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      Utils.MSG_Debug("false - no internet");
      return false; // No internet connection
    } else {
      Utils.MSG_Debug("true - successful connection with the internet");
      return true; // Internet connection is available
    }
  }
}
