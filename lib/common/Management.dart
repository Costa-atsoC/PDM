import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as HTTP;

import '../General.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import 'Utils.dart';


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
    ACCESS_NUMBER = 0;
  }

  //--------------------------------------
  Future<void> Load() async {
    String? LANGUAGE = await Get_SharedPreferences_STRING('LANGUAGE');
    if(LANGUAGE == "??" || LANGUAGE == 'EN'){
        //------------------------------------------------------//
        //------------------ WINDOW MAIN EN --------------------//
        //------------------------------------------------------//

        //--------- TOP
        //DEFINICOES.Add("TITULO_APP", "REVS & ROASTS");
        SETTINGS.Add("TITULO_APP", "rideWME");

        //--------- CENTER
        SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT", "Greetings! Welcome to RideWithME!");
        SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT_LOGGED", "Welcome back, ");

        SETTINGS.Add("WND_LOGIN_HINT_1", "Email");
        SETTINGS.Add("WND_LOGIN_HINT_1_SIZE", "20");
        SETTINGS.Add("WND_LOGIN_HINT_1_WARNING", "Please enter your email");

        SETTINGS.Add("WND_LOGIN_HINT_2", "Password");
        SETTINGS.Add("WND_LOGIN_HINT_2_SIZE", "20");
        SETTINGS.Add("WND_LOGIN_HINT_2_WARNING", "Please enter your password");

        SETTINGS.Add("WND_LOGIN_CHECKBOX_LABEL_1", "Remember me");

        SETTINGS.Add("WND_LOGIN_BTN_2", "Forgot Password?");

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
        SETTINGS.Add("WND_REGISTER_TITLE_1",
            "Create a RideWithME account");
        SETTINGS.Add("WND_REGISTER_SUBTITLE_1",
            "Start your journey Carpooling or being Carpooled now!");

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

        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_TITLE_1",
            "By creating an account, you are accepting the");
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS",
          "Terms & Conditions");
        SETTINGS.Add( "WND_REGISTER_TERMS_CONDITIONS_TITLE_2",
            'By using our carpooling service, you agree to the following terms and conditions:');
        SETTINGS.Add( "WND_REGISTER_TERMS_CONDITIONS_1",
            '1. You must be at least 18 years old to use this app.');
        SETTINGS.Add( "WND_REGISTER_TERMS_CONDITIONS_2",
            '2. Users are responsible for their own safety during rides.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_3",
            '3. Respect other users and their personal space.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_4",
            "4. Follow traffic laws and regulations during carpooling.");
        SETTINGS.Add(   "WND_REGISTER_TERMS_CONDITIONS_5",
            '5. The app is not responsible for any disputes between users.');
        SETTINGS.Add( "WND_REGISTER_TERMS_CONDITIONS_6",
            '6. Users are encouraged to report any inappropriate behavior.');
        SETTINGS.Add(  "WND_REGISTER_TERMS_CONDITIONS_7",
            '7. The app may use location data for the purpose of carpool matching.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_8",
            '8. Users should verify the identity of their carpooling partners.');
        SETTINGS.Add(   "WND_REGISTER_TERMS_CONDITIONS_9",
            '9. The app may suspend or terminate users violating these terms.');
        SETTINGS.Add( "WND_REGISTER_TERMS_CONDITIONS_10",
            '10. By using the app, you consent to our privacy policy.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_BTN_1",
            'Close');
        //--------- FIM DA JANELA REGISTER

        //------------------------------------------------------//
        //----------------- WINDOW HOME ------------------------//
        //------------------------------------------------------//

        //--------- ANIMATION
        SETTINGS.Add("WND_HOME_ANIMATION_DURATION_1", "200"); // in ms

        //--------- TEXT
        SETTINGS.Add("WND_HOME_TITLE_1", "");
        SETTINGS.Add("WND_HOME_TITLE_1_SIZE", "30");

        //--------- DRAWER
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_SIZE", "25");
        String? USER_NAME = await Get_SharedPreferences_STRING('NAME');
        if (USER_NAME != null) {
          Utils.MSG_Debug(USER_NAME);
          SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", USER_NAME);
        }


        //--------- ICONS

        //------- FUNCTIONS HOME
        int? JNL_HOME_NUMERO_ACESSOS =
        await Get_SharedPreferences_INT('JNL_HOME_NUMERO_ACESSOS');
        if (JNL_HOME_NUMERO_ACESSOS != null) {
          //JNL_HOME_NUMERO_ACESSOS++;
          Save_Shared_Preferences_INT(
              'JNL_HOME_NUMERO_ACESSOS', JNL_HOME_NUMERO_ACESSOS + 1);
        }

        //------- FUNCTIONS HOME
        String? FULL_NAME = await Get_SharedPreferences_STRING('NAME');
        if (FULL_NAME != null) {
          (FULL_NAME);
          SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", FULL_NAME);
          SETTINGS.Add("WND_USER_PROFILE_TITLE_1", FULL_NAME);
        }

        //------------------------------------------------------//
        //--------------- WINDOW FORGOT PASSWORD----------------//
        //------------------------------------------------------//
        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_1", "Go Back");
        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_1_SIZE", "15");
        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_1_ICON", "RideWME");

        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_2",
            "Enter your Email and we will send you a password reset link");
        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_2_SIZE", "15");
        SETTINGS.Add("WND_FORGOT_PASSWORD_TITLE_2_ICON", "RideWME");

        SETTINGS.Add("WND_FORGOT_PASSWORD_BTN_1_TEXT",
            "RESET PASSWORD");
        SETTINGS.Add("WND_FORGOT_PASSWORD_BTN_1_TEXT_SIZE", "15");

        //--------- FUNÇÕES
        int? NUMERO_ACESSOS = await Get_SharedPreferences_INT('NUMERO_ACESSOS');
        if (NUMERO_ACESSOS != null) {
          //NUMERO_ACESSOS++;
          Save_Shared_Preferences_INT('NUMERO_ACESSOS', NUMERO_ACESSOS + 1);
          //("NUMERO_ACESSOS = $NUMERO_ACESSOS");
        }

        String? NOTICIAS = await Get_SharedPreferences_STRING('NOTICIAS');
        if (NOTICIAS != null) {
          SETTINGS.Add("NOTICIAS", NOTICIAS);
        }

        SETTINGS.Mostrar(2);

        //------------------------------------------------------//
        //----------------- WINDOW PROFILE----------------------//
        //------------------------------------------------------//

        if (FULL_NAME != null) {
          SETTINGS.Add("WND_USER_PROFILE_TITLE_1", FULL_NAME);
        }

        String? LOCATION = await Get_SharedPreferences_STRING('LOCATION');
        SETTINGS.Add("WND_USER_PROFILE_LOCATION", LOCATION!);

        String? USERNAME = await Get_SharedPreferences_STRING('USERNAME');
        SETTINGS.Add("WND_USER_PROFILE_USERNAME", USERNAME!);

        String? UID = await Get_SharedPreferences_STRING('UID');
        SETTINGS.Add('WND_USER_PROFILE_UID', UID!);

        SETTINGS.Add("WND_USER_PROFILE_MEM", "Member since: ");

        String? REGISTERDATE = await Get_SharedPreferences_STRING('REGDATE');
        SETTINGS.Add('WND_USER_PROFILE_REGDATE', REGISTERDATE!);

        String? LOGINDATE = await Get_SharedPreferences_STRING('LOGINDATE_FORMATED');
        SETTINGS.Add('WND_USER_PROFILE_LOGIN_DATE', LOGINDATE!);

        SETTINGS.Add("WND_USER_PROFILE_LAST_ONLINE", "Last seen: ");

        String? SIGNOUTDATE = await Get_SharedPreferences_STRING('SIGNOUTDATE');
        SETTINGS.Add('WND_USER_PROFILE_SIGNOUT_DATE', SIGNOUTDATE!);

        //------------------------------------------------------//
        //-------------------- DRAWER --------------------------//
        //------------------------------------------------------//
        
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1", "HOME");
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

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_6", "FAQ");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_6_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "RideWME");


      }


///-----------------------------------------------------------///
///-----------------------------------------------------------///
///-----------------------PORTUGUÊS---------------------------///
///-----------------------------------------------------------///
///-----------------------------------------------------------///

    else if(LANGUAGE == 'PT'){
        //------------------------------------------------------//
        //------------------ JANELA PRINCIPAL PT ---------------//
        //------------------------------------------------------//

        //--------- TOPO
        SETTINGS.Add("TITULO_APP", "rideWME");

        //--------- CENTRO
        SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT", "Olá! Bem-vindo ao RideWithME!");
        SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT_LOGGED", "Bem-vindo de volta, ");

        SETTINGS.Add("WND_LOGIN_HINT_1", "Email");
        SETTINGS.Add("WND_LOGIN_HINT_1_SIZE", "20");
        SETTINGS.Add("WND_LOGIN_HINT_1_WARNING", "Por favor insira o seu email");

        SETTINGS.Add("WND_LOGIN_HINT_2", "Palavra-passe");
        SETTINGS.Add("WND_LOGIN_HINT_2_SIZE", "20");
        SETTINGS.Add("WND_LOGIN_HINT_2_WARNING", "Por favor insira a sua palavra-passe");

        SETTINGS.Add("WND_LOGIN_CHECKBOX_LABEL_1", "Lembrar-se de mim");

        SETTINGS.Add("WND_LOGIN_BTN_2", "Esqueceu-se da\npalavra-passe?");

        SETTINGS.Add("WND_LOGIN_BTN_1", "ENTRAR");

        SETTINGS.Add("TEXT_NEW_WINDOW_REGISTER", "Página de Registo");
        SETTINGS.Add("TEXT_OF_BUTTON_REGISTER", "Não tem conta? Clique aqui");
        SETTINGS.Add("TAMANHO_TEXTO_BTN_NEW_REGISTER", "20");

        //--------- FUNDO
        //---------- FIM DA JANELA PRINCIPAL

        //------------------------------------------------------//
        //--------------- JANELA DE REGISTO --------------------//
        //------------------------------------------------------//
        SETTINGS.Add("WND_REGISTER_TITLE_1",
            "Crie uma conta RideWithME");
        SETTINGS.Add("WND_REGISTER_SUBTITLE_1",
            "Inicie a sua jornada a partilhar boleias agora!");


        SETTINGS.Add("WND_REGISTER_OBSTEXT_1", "true");
        SETTINGS.Add("WND_REGISTER_OBSTEXT_2", "true");

        SETTINGS.Add("WND_REGISTER_HINT_1", "Email");
        SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_EMAIL_REGISTER", "20");

        SETTINGS.Add("WND_REGISTER_HINT_2", "Nome de Utilizador");
        SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME_REGISTER", "20");

        SETTINGS.Add("WND_REGISTER_HINT_3", "Palavra-passe");
        SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD_REGISTER", "20");

        SETTINGS.Add("WND_REGISTER_HINT_4", "Confirmar Palavra-passe");
        SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_RPPASSWORD_REGISTER", "20");

        SETTINGS.Add("WND_REGISTER_HINT_5", "Nome Completo");
        SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_FULLNAME", "20");

        SETTINGS.Add("WND_REGISTER_BTN_1", "REGISTAR");

        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_TITLE_1",
            "Ao criar uma conta, está a aceitar os");
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS",
            "Termos e Condições");
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_TITLE_2",
            'Ao utilizar o nosso serviço de boleias, concorda com os seguintes termos e condições:');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_1",
            '1. Deve ter pelo menos 18 anos para utilizar esta aplicação.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_2",
            '2. Os utilizadores são responsáveis pela sua própria segurança durante as viagens.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_3",
            '3. Respeite outros utilizadores e o seu espaço pessoal.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_4",
            '4. Cumpra as leis e regulamentos de trânsito durante o carpooling.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_5",
            '5. A aplicação não é responsável por disputas entre utilizadores.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_6",
            '6. Encoraja-se os utilizadores a denunciarem comportamentos inapropriados.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_7",
            '7. A aplicação pode utilizar dados de localização para efeitos de correspondência de carpooling.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_8",
            '8. Os utilizadores devem verificar a identidade dos seus parceiros de carpooling.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_9",
            '9. A aplicação pode suspender ou terminar utilizadores que violem estes termos.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_10",
            '10. Ao utilizar a aplicação, consente com a nossa política de privacidade.');
        SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_BTN_1",
            'Fechar');
        //--------- FIM DA JANELA DE REGISTO

        //------------------------------------------------------//
        //------------------ JANELA INICIAL --------------------//
        //------------------------------------------------------//

        //--------- ANIMAÇÃO
        SETTINGS.Add("WND_HOME_ANIMATION_DURATION_1", "200"); // em ms

        //--------- TEXTO
        SETTINGS.Add("WND_HOME_TITLE_1", "");
        SETTINGS.Add("WND_HOME_TITLE_1_SIZE", "30");

        //--------- MENU LATERAL
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_SIZE", "25");
        String? NOME_UTILIZADOR = await Get_SharedPreferences_STRING('NOME');
        if (NOME_UTILIZADOR != null) {
          Utils.MSG_Debug(NOME_UTILIZADOR);
          SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", NOME_UTILIZADOR);
        }


        //------------------------------------------------------//
        //----------------- WINDOW PROFILE----------------------//
        //------------------------------------------------------//

        //------- FUNCTIONS HOME
        String? FULL_NAME = await Get_SharedPreferences_STRING('NAME');
        if (FULL_NAME != null) {
          (FULL_NAME);
          SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", FULL_NAME);
          SETTINGS.Add("WND_USER_PROFILE_TITLE_1", FULL_NAME);
        }


        if (FULL_NAME != null) {
          SETTINGS.Add("WND_USER_PROFILE_TITLE_1", FULL_NAME);
        }

        //String? LOCATION = await Get_SharedPreferences_STRING('LOCATION');
        //SETTINGS.Add("WND_USER_PROFILE_LOCATION", LOCATION!);

        //String? USERNAME = await Get_SharedPreferences_STRING('USERNAME');
        //SETTINGS.Add("WND_USER_PROFILE_USERNAME", USERNAME!);

        //String? UID = await Get_SharedPreferences_STRING('UID');
        //SETTINGS.Add('WND_USER_PROFILE_UID', UID!);

        SETTINGS.Add("WND_USER_PROFILE_MEM", "Membro desde: ");

        //String? REGISTERDATE = await Get_SharedPreferences_STRING('REGDATE');
        //SETTINGS.Add('WND_USER_PROFILE_REGDATE', REGISTERDATE!);

        //String? LOGINDATE = await Get_SharedPreferences_STRING('LOGINDATE_FORMATED');
        //SETTINGS.Add('WND_USER_PROFILE_LOGIN_DATE', LOGINDATE!);

        SETTINGS.Add("WND_USER_PROFILE_LAST_ONLINE", "Última vez visto: ");

        //String? SIGNOUTDATE = await Get_SharedPreferences_STRING('SIGNOUTDATE');
        //SETTINGS.Add('WND_USER_PROFILE_SIGNOUT_DATE', SIGNOUTDATE!);

        //------------------------------------------------------//
        //-------------------- DRAWER --------------------------//
        //------------------------------------------------------//

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1", "PÁGINA INICIAL");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_ICON", "rideWME");

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2", "PERFIL");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_2_ICON", "rideWME");

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3", "DEFINIÇÕES");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "rideWME");

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4", "FEEDBACK");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_4_ICON", "rideWME");

        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5", "SAIR");
        SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5_SIZE", "15");
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_5_ICON", "rideWME");

        //--------- ÍCONES

        //------- FUNÇÕES INICIAIS

        //------- FUNÇÕES INICIAIS
        String? NOME_COMPLETO = await Get_SharedPreferences_STRING('NOME');
        if (NOME_COMPLETO != null) {
          (NOME_COMPLETO);
          SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", NOME_COMPLETO);
          SETTINGS.Add("WND_USER_PROFILE_TITLE_1", NOME_COMPLETO);
        }
      }
    else if (LANGUAGE == 'DE') {
      //------------------------------------------------------//
      //------------------ HAUPTFENSTER DE -------------------//
      //------------------------------------------------------//

      //--------- HEADER
      SETTINGS.Add("TITULO_APP", "rideWME");

      //--------- BODY
      SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT", "Hallo! Willkommen bei RideWithME!");
      SETTINGS.Add("WND_LOGIN_TITLE_1_TEXT_LOGGED", "Willkommen zurück, ");

      SETTINGS.Add("WND_LOGIN_HINT_1", "E-Mail");
      SETTINGS.Add("WND_LOGIN_HINT_1_SIZE", "20");
      SETTINGS.Add("WND_LOGIN_HINT_1_WARNING", "Bitte geben Sie Ihre E-Mail ein");

      SETTINGS.Add("WND_LOGIN_HINT_2", "Passwort");
      SETTINGS.Add("WND_LOGIN_HINT_2_SIZE", "20");
      SETTINGS.Add("WND_LOGIN_HINT_2_WARNING", "Bitte geben Sie Ihr Passwort ein");

      SETTINGS.Add("WND_LOGIN_CHECKBOX_LABEL_1", "An mich erinnern");

      SETTINGS.Add("WND_LOGIN_BTN_2", "Passwort\nvergessen?");

      SETTINGS.Add("WND_LOGIN_BTN_1", "ANMELDEN");

      SETTINGS.Add("TEXT_NEW_WINDOW_REGISTER", "Registrierungsseite");
      SETTINGS.Add("TEXT_OF_BUTTON_REGISTER", "Kein Konto? Hier klicken");
      SETTINGS.Add("TAMANHO_TEXTO_BTN_NEW_REGISTER", "20");

      //--------- BACKGROUND
      //---------- ENDE DES HAUPTFENSTERS

      //------------------------------------------------------//
      //--------------- REGISTRIERUNGSFENSTER DE --------------//
      //------------------------------------------------------//
      SETTINGS.Add("WND_REGISTER_TITLE_1", "RideWithME Konto erstellen");
      SETTINGS.Add("WND_REGISTER_SUBTITLE_1", "Starten Sie jetzt Ihre Fahrgemeinschaftsreise!");

      SETTINGS.Add("WND_REGISTER_OBSTEXT_1", "true");
      SETTINGS.Add("WND_REGISTER_OBSTEXT_2", "true");

      SETTINGS.Add("WND_REGISTER_HINT_1", "E-Mail");
      SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_EMAIL_REGISTER", "20");

      SETTINGS.Add("WND_REGISTER_HINT_2", "Benutzername");
      SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_USERNAME_REGISTER", "20");

      SETTINGS.Add("WND_REGISTER_HINT_3", "Passwort");
      SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_PASSWORD_REGISTER", "20");

      SETTINGS.Add("WND_REGISTER_HINT_4", "Passwort bestätigen");
      SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_RPPASSWORD_REGISTER", "20");

      SETTINGS.Add("WND_REGISTER_HINT_5", "Vollständiger Name");
      SETTINGS.Add("TAMANHO_TEXTO_TEXTFIELD_FULLNAME", "20");

      SETTINGS.Add("WND_REGISTER_BTN_1", "REGISTRIEREN");

      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_TITLE_1", "Durch die Erstellung eines Kontos akzeptieren Sie die");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS", "Nutzungsbedingungen");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_TITLE_2", "Durch die Nutzung unseres Fahrgemeinschaftsdienstes stimmen Sie den folgenden Nutzungsbedingungen zu:");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_1", "1. Sie müssen mindestens 18 Jahre alt sein, um diese Anwendung zu verwenden.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_2", "2. Benutzer sind für ihre eigene Sicherheit während der Fahrten verantwortlich.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_3", "3. Respektieren Sie andere Benutzer und ihren persönlichen Raum.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_4", "4. Befolgen Sie die Verkehrs- und Sicherheitsvorschriften während der Fahrgemeinschaft.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_5", "5. Die Anwendung ist nicht für Streitigkeiten zwischen Benutzern verantwortlich.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_6", "6. Benutzer werden ermutigt, unangemessenes Verhalten zu melden.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_7", "7. Die Anwendung kann Standortdaten für das Matching von Fahrgemeinschaften verwenden.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_8", "8. Benutzer müssen die Identität ihrer Fahrgemeinschaftspartner überprüfen.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_9", "9. Die Anwendung kann Benutzer, die gegen diese Bedingungen verstoßen, suspendieren oder beenden.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_10", "10. Durch die Verwendung der Anwendung stimmen Sie unserer Datenschutzrichtlinie zu.");
      SETTINGS.Add("WND_REGISTER_TERMS_CONDITIONS_BTN_1", "Schließen");
      //--------- ENDE DES REGISTRIERUNGSFENSTERS

      //------------------------------------------------------//
      //------------------ STARTFENSTER DE --------------------//
      //------------------------------------------------------//
      SETTINGS.Add("WND_HOME_ANIMATION_DURATION_1", "200"); // in ms

      SETTINGS.Add("WND_HOME_TITLE_1", "");
      SETTINGS.Add("WND_HOME_TITLE_1_SIZE", "30");

      SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_SIZE", "25");
      String? NUTZERNAME = await Get_SharedPreferences_STRING('NUTZERNAME');
      if (NUTZERNAME != null) {
        Utils.MSG_Debug(NUTZERNAME);
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", NUTZERNAME);
      }


      //------------------------------------------------------//
      //----------------- PROFILFENSTER DE ----------------------//
      //------------------------------------------------------//
      SETTINGS.Add("WND_USER_PROFILE_MEM", "Mitglied seit: ");
      SETTINGS.Add("WND_USER_PROFILE_LAST_ONLINE", "Zuletzt gesehen: ");

      //------------------------------------------------------//
      //-------------------- SEITENLEISTE DE --------------------------//
      //------------------------------------------------------//

      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1", "STARTSEITE");
      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_1_SIZE", "15");
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_1_ICON", "rideWME");

      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2", "PROFIL");
      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_2_SIZE", "15");
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_2_ICON", "rideWME");

      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3", "EINSTELLUNGEN");
      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_3_SIZE", "15");
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_3_ICON", "rideWME");

      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4", "FEEDBACK");
      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_4_SIZE", "15");
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_4_ICON", "rideWME");

      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5", "ABMELDEN");
      SETTINGS.Add("WND_HOME_DRAWER_SUBTITLE_5_SIZE", "15");
      SETTINGS.Add("WND_HOME_DRAWER_TITLE_5_ICON", "rideWME");

      //--------- SYMBOLE

      //------- STARTFUNKTIONEN

      //------- STARTFUNKTIONEN
      String? VOLLER_NAME2 = await Get_SharedPreferences_STRING('VOLLER_NAME');
      if (VOLLER_NAME2 != null) {
        (VOLLER_NAME2);
        SETTINGS.Add("WND_HOME_DRAWER_TITLE_1", VOLLER_NAME2);
        SETTINGS.Add("WND_USER_PROFILE_TITLE_1", VOLLER_NAME2);
      }
    }

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
  void saveNumAccess(String TAG) async{
    int? numAccess = await Get_SharedPreferences_INT(TAG);
    if (numAccess == null){
      Save_Shared_Preferences_INT(TAG, 1);
    }
    if (numAccess != null) {
      Save_Shared_Preferences_INT(TAG, numAccess + 1);
      Utils.MSG_Debug('$TAG -> $numAccess');
    }
  }

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
  Future<List<PostModel>> GET_Shared_Preferences_LIST(String TAG) async {
    List<PostModel> posts = [];
    final SharedPreferences pfs = await prefs;
    List<String> postsJson = pfs.getStringList(TAG) ?? [];

    for (String json in postsJson) {
      Map<String, dynamic> data = jsonDecode(json);
      PostModel post = PostModel.fromJson(data);
      posts.add(post);
    }

    return posts;
  }

  //---------

  void Save_Shared_Preferences_INT(String TAG, int Valor) async {
    final SharedPreferences pfs = await prefs;
    pfs.setInt(TAG, Valor);
  }

  //--------------------------------------
  void Save_Shared_Preferences_STRING(String TAG, String Valor) async {
    final SharedPreferences pfs = await prefs;
    pfs.setString(TAG, Valor);
  }

  void Save_Shared_Preferences_LIST(String TAG, List<PostModel> posts) async {
    final SharedPreferences pfs = await prefs;
    List<String> postsJson = posts.map((post) => jsonEncode(post.toJson())).toList();
    pfs.setStringList(TAG, postsJson);
  }



  //--------------------------------------
  Future<Object?> Delete_Shared_Preferences(String TAG) async {
    final SharedPreferences pfs = await prefs;
    if (pfs == null) {
      ("$TAG doens't exist");
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
// Future NavigateTo_Window_User_Profile(context) async {
//   windowUserProfile win = new windowUserProfile(Management as Management);
//   await win.Load();
//   Navigator.push(context, MaterialPageRoute(builder: (context) => win));
// }
}
