import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as HTTP;

import '../General.dart';
import 'Utils.dart';

import '../screens/windowUserProfile.dart';

class Management {
  final String appName;

  General SETTINGS = General("Settings");

  var Lista_Icones = <IconData>{};
  int ACCESS_NUMBER = 0;

  final icons = [
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_railway,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.directions_transit,
    Icons.directions_walk,
    Icons.book
  ];

  // VER https://www.macoratti.net/19/11/flut_shapref1.htm
  // https://medium.flutterdevs.com/using-sharedpreferences-in-flutter-251755f07127
  // https://pub.dev/packages/shared_preferences
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  //--------------------------------------
  Management(this.appName) {
    Utils.MSG_Debug("Management");
    ACCESS_NUMBER = 0;
  }

  //--------------------------------------
  Future<void> Load() async {
    //------------------------------------------------------//
    //------------------ WINDOW MAIN -----------------------//
    //------------------------------------------------------//

    //--------- TOP
    //DEFINICOES.Add("TITULO_APP", "REVS & ROASTS");
    SETTINGS.Add("TITULO_APP", "rideWME");

    //--------- CENTER
    SETTINGS.Add("WND_LOGIN_TITLE_1", "Login Window");

    SETTINGS.Add("WND_LOGIN_HINT_1", "Username");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME", "20");

    SETTINGS.Add("WND_LOGIN_HINT_2", "Password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD", "20");

    SETTINGS.Add("WND_LOGIN_BTN_1", "LOGIN");

    SETTINGS.Add("TEXT_NEW_WINDOW_REGISTER", "Register Page");
    SETTINGS.Add(
        "TEXT_OF_BUTTON_REGISTER", "Don't have an account? Click here");
    SETTINGS.Add("TAMANHO_TEXTO_BTN_NEW_REGISTER", "20");

    //--------- BOTTOM
    //---------- FIM DA MAIN

    //------------------------------------------------------//
    //--------------- WINDOW REGISTER ----------------------//
    //------------------------------------------------------//
    SETTINGS.Add("WND_REGISTER_TITLE_1", "Register Window");

    SETTINGS.Add("WND_REGISTER_OBSTEXT_1", "true");
    SETTINGS.Add("WND_REGISTER_OBSTEXT_2", "true");

    SETTINGS.Add("WND_REGISTER_HINT_1", "Email");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_EMAIL_REGISTER", "20");

    SETTINGS.Add("WND_REGISTER_HINT_2", "Username");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME_REGISTER", "20");

    SETTINGS.Add("WND_REGISTER_HINT_3", "Password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD_REGISTER", "20");

    SETTINGS.Add("WND_REGISTER_HINT_4", "Confirm the password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_RPPASSWORD_REGISTER", "20");

    SETTINGS.Add("WND_REGISTER_HINT_5", "Full Name");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_FULLNAME", "20");

    SETTINGS.Add("WND_REGISTER_BTN_1", "REGISTER");
    //--------- FIM DA JANELA REGISTER

    //------------------------------------------------------//
    //----------------- WINDOW HOME ------------------------//
    //------------------------------------------------------//

    //--------- TEXT
    SETTINGS.Add("WND_HOME_TITLE_1", "");
    SETTINGS.Add("WND_HOME_TITLE_1_SIZE", "30");

    //--------- DRAWER
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", "Name");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_SIZE", "25");

    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1", "WELCOME");
    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1_SIZE", "15");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_ICON", "RideWME");

    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2", "PROFILE");
    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2_SIZE", "15");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_2_ICON", "RideWME");

    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3", "SETTINGS");
    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3_SIZE", "15");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "RideWME");

    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4", "FEEDBACK");
    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4_SIZE", "15");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "RideWME");

    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5", "LOGOUT");
    SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5_SIZE", "15");
    SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "RideWME");
    //--------- END OF DRAWER

    //--------- ICONS

    //------- FUNCTIONS HOME
    int? JNL_HOME_NUMERO_ACESSOS =
        await Get_SharedPreferences_INT('JNL_HOME_NUMERO_ACESSOS');
    if (JNL_HOME_NUMERO_ACESSOS != null) {
      //JNL_HOME_NUMERO_ACESSOS++;
      Save_Shared_Preferences_INT(
          'JNL_HOME_NUMERO_ACESSOS', JNL_HOME_NUMERO_ACESSOS + 1);
      Utils.MSG_Debug("JNL_HOME_NUMERO_ACESSOS = $JNL_HOME_NUMERO_ACESSOS");
    }

    //------- FUNCTIONS HOME
    String? USER_NAME = await Get_SharedPreferences_STRING('NAME');
    if (USER_NAME != null) {
      Utils.MSG_Debug(USER_NAME!);
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", USER_NAME!);
    }

    //--------- FIM DA JANELA HOME

    //------------------------------------------------------//
    //----------------- WINDOW HOME ------------------------//
    //------------------------------------------------------//
    SETTINGS.Add("WND_PROFILE_TITLE_1", "User Profile");

    //--------- FUNÇÕES
    int? NUMERO_ACESSOS = await Get_SharedPreferences_INT('NUMERO_ACESSOS');
    if (NUMERO_ACESSOS != null) {
      //NUMERO_ACESSOS++;
      Save_Shared_Preferences_INT('NUMERO_ACESSOS', NUMERO_ACESSOS + 1);
      Utils.MSG_Debug("NUMERO_ACESSOS = $NUMERO_ACESSOS");
    }

    String? NOTICIAS = await Get_SharedPreferences_STRING('NOTICIAS');
    if (NOTICIAS != null) {
      SETTINGS.Add("NOTICIAS", NOTICIAS);
    }

    SETTINGS.Mostrar(2);
  }

  //--------------------------------------
  String GetDefinicao(String key, String def) {
    return SETTINGS.Get(key, def);
  }

  //--------------------------------------
  String GetDadosUtilizadores() {
    return "Dados dos Utilizadores";
  }

  //--------------------------------------
  //--------------------------------------
  //--------------------------------------
  Future<int?> Get_SharedPreferences_INT(String TAG) async {
    final SharedPreferences pfs = await prefs;
    if (pfs == null) return 0;
    if (pfs.containsKey(TAG)) {
      return pfs.getInt(TAG);
    }
    return 0;
  }

  //--------------------------------------
  Future<String?> Get_SharedPreferences_STRING(String TAG) async {
    final SharedPreferences pfs = await prefs;
    if (pfs == null) return "??";
    if (pfs.containsKey(TAG)) {
      return pfs.getString(TAG);
    }
    return "??";
  }

  //---------

  void Save_Shared_Preferences_INT(String TAG, int Valor) async {
    final SharedPreferences pfs = await prefs;
    pfs.setInt(TAG, Valor);
    Utils.MSG_Debug(TAG + "=" + Valor.toString());
  }

  //--------------------------------------
  void Save_Shared_Preferences_STRING(String TAG, String Valor) async {
    final SharedPreferences pfs = await prefs;
    pfs.setString(TAG, Valor);
    Utils.MSG_Debug(TAG + "=" + Valor);
  }

  //--------------------------------------
  Future<Object?> Delete_Shared_Preferences(String TAG) async {
    final SharedPreferences pfs = await prefs;
    if (pfs == null) {
      Utils.MSG_Debug("$TAG doens't exist");
      return "$TAG doesn't exist";
    }
    if (pfs.containsKey(TAG)) {
      await pfs.remove(TAG);
      Utils.MSG_Debug("$TAG removed");
      return "$TAG deleted";
    }
    Utils.MSG_Debug("$TAG not deleted, there was a error");
    return "$TAG not deleted";
  }

  Future<String> ExecutaServidor() async {
    Utils.MSG_Debug("INICIO: ExecutaServidor!");
    String Resposta_Servidor = "";
    HTTP.Client Servidor = HTTP.Client();
    try {
      //String str_servidor = "http://solar.f2mobile.eu/servico_solar_V1_0.php";
      String str_servidor = "http://feeds.jn.pt/JN-Ultimas";
      var url = Uri.parse(str_servidor);
      var response = await Servidor.get(url);
      //var response = await Servidor.post(str_servidor, body: {'ACCAO': 'GET_CLIENTS', 'color': 'blue'});
      if (response.statusCode == 200) {
        Utils.MSG_Debug("Resposta SERVIDOR Valida!");
        Resposta_Servidor = response.body;
        Utils.MSG_Debug("Resposta : " + Resposta_Servidor);
        Save_Shared_Preferences_STRING("NOTICIAS", Resposta_Servidor);
      } else {
        Utils.MSG_Debug("Resposta SERVIDOR Invalida!");
      }
    } finally {
      Servidor.close();
      Utils.MSG_Debug("ExecutaServidor: finally");
    }
    Utils.MSG_Debug("FIM: ExecutaServidor!");
    return Resposta_Servidor;
  }

  //-------- WINDOW FUNCTIONS
  Future NavigateTo_Window_User_Profile(context) async {
    windowUserProfile win = new windowUserProfile(Management as Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }
}
