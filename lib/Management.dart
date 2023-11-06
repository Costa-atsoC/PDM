import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as HTTP;

import 'General.dart';
import 'Utils.dart';

import 'windowUserProfile.dart';

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
    //--------- MAIN

    //--------- TOP
    //DEFINICOES.Add("TITULO_APP", "REVS & ROASTS");
    SETTINGS.Add("TITULO_APP", "rideWM");

    //--------- CENTER
    SETTINGS.Add("TEXTO_1", "Carregou tantas vezes no botãooooo!");
    SETTINGS.Add("TITULO_BTN_1", "Botao 1 Experiência");
    SETTINGS.Add("TITULO_BTN_2", "Botao 2");
    SETTINGS.Add("ACCAO_BTN_3", "Exemplo de uma mensagem");
    SETTINGS.Add("TITULO_BTN_3", "Mensagem.NOVA DO BTN_3..");
    SETTINGS.Add("TEXT_OF_BUTTON_NEW", "Message of NEW BUTTON");

    //DEFINICOES.Add("TEXT_NEW_WINDOW_LOGIN", "Login");
    //DEFINICOES.Add("TAMANHO_TEXTO_BTN_NEW_LOGIN", "20");
    SETTINGS.Add("TEXT_NEW_WINDOW_REGISTER", "Register Page");
    SETTINGS.Add(
        "TEXT_OF_BUTTON_REGISTER", "If you don't have an account, click here");
    SETTINGS.Add("TAMANHO_TEXTO_BTN_NEW_REGISTER", "20");

    //--------- BOTTOM
    //---------- FIM DA MAIN

    //--------- JANELA LOGIN
    SETTINGS.Add("JNL_LOGIN_TITLE_1", "Login Window");

    SETTINGS.Add("JNL_LOGIN_HINT_1", "Username");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME", "20");

    SETTINGS.Add("JNL_LOGIN_HINT_2", "Password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD", "20");

    SETTINGS.Add("JNL_LOGIN_BTN_1", "Login");
    //--------- FIM DA JANELA LOGIN

    //---------JANELA REGISTER
    SETTINGS.Add("JNL_REGISTER_TITLE_1", "Register Window");

    SETTINGS.Add("JNL_REGISTER_OBSTEXT_1", "false");
    SETTINGS.Add("JNL_REGISTER_OBSTEXT_2", "false");

    SETTINGS.Add("JNL_REGISTER_HINT_1", "Email");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_EMAIL_REGISTER", "20");

    SETTINGS.Add("JNL_REGISTER_HINT_2", "Username");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME_REGISTER", "20");

    SETTINGS.Add("JNL_REGISTER_HINT_3", "Password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD_REGISTER", "20");

    SETTINGS.Add("JNL_REGISTER_HINT_4", "Confirm the password");
    SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_RPPASSWORD_REGISTER", "20");

    SETTINGS.Add("JNL_REGISTER_BTN_1", "Submit ");
    //--------- FIM DA JANELA REGISTER

    //--------- JANELA HOME
    SETTINGS.Add("JNL_HOME_TITLE_1", "HomePage");
    SETTINGS.Add("JNL_DRAWER_TITLE_1", "RideWME");

    int? JNL_HOME_NUMERO_ACESSOS =
        await Get_SharedPreferences_INT('JNL_HOME_NUMERO_ACESSOS');
    if (JNL_HOME_NUMERO_ACESSOS != null) {
      //JNL_HOME_NUMERO_ACESSOS++;
      Save_Shared_Preferences_INT(
          'JNL_HOME_NUMERO_ACESSOS', JNL_HOME_NUMERO_ACESSOS + 1);
      Utils.MSG_Debug("JNL_HOME_NUMERO_ACESSOS = $JNL_HOME_NUMERO_ACESSOS");
    }

    SETTINGS.Add("TITULO_BTN_SHARED_PREFERENCE", "Nº de cliques");
    SETTINGS.Add("TITULO_BTN_LISTVIEW", "ListView");
    SETTINGS.Add("TITULO_BTN_PEDIDO_SERVIDOR", "Pedido ao Servidor 18/10/2023");
    SETTINGS.Add("TITULO_BTN_LINKS_UTEIS", "Links Uteis para a Disciplina!");

    SETTINGS.Add("NOTICIAS_TITULO", "Notícias + Dia de Hoje");

    //--------- FIM DA JANELA HOME

    //--------- JANELA LISTVIEW COM LINKS
    //--------- FIM DA JANELA LISTVIEW COM LINKS

    //--------- JANELA NOTICIAS
    SETTINGS.Add("JANELA_NOTICIAS_NOTITLE", "Sem título");
    SETTINGS.Add("JANELA_NOTICIAS_NOPUBDATE", "Sem data de publicação");
    SETTINGS.Add("JANELA_NOTICIAS_NODESCRIPTION", "Sem descrição");

    SETTINGS.Add("JANELA_NOTICIAS_TITLE", "title");
    SETTINGS.Add("JANELA_NOTICIAS_PUBDATE", "pubDate");
    SETTINGS.Add("JANELA_NOTICIAS_DESCRIPTION", "description");

    //--------- FIM DA JANELA NOTICIAS

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
