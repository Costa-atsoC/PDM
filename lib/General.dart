import 'dart:core';
import 'common/Utils.dart';

/*
Geral X = Geral("PESSOA");
X.Add("ID", "123");
X.Add("NOME", "Zezito");
X.Add("IDADE", "23");

Geral X = Geral("PRODUTO");
X.Add("I D", "123");
X.Add("NOME", "Arroz");
X.Add("IMAGEM", "https://sdsds/sd/sd/sdsd/arroz.png");
X.Add("PRECO", "1.23")

String aux = X.Get("ID", "O pá o ID nao existe!")
*/
class General {
  Map<String, String> Dados = Map();
  final String NomeObjecto;

  //----------------------------------------
  General(this.NomeObjecto);

  //----------------------------------------
  String GetNome() {
    return NomeObjecto;
  }

  //----------------------------------------
  Map<String, String> Get_All_Dados() {
    return Dados;
  }

  //----------------------------------------
  void Add(String key, String valor) {
    Dados[key] = valor;
  }

  //----------------------------------------
  String Get(String key, String def) {
    if (Dados.containsKey(key)) {
      return Dados[key].toString();
    }
    return def;
  }

  //----------------------------------------
  Iterable<String> GetKeys() {
    return Dados.keys;
  }

  //----------------------------------------
  void Mostrar(int N) {
    String strEspacos = Utils.CriarEspacos(N, "--");
    Utils.MSG_Debug("ObjectoGeral: " + NomeObjecto!);
    Iterable<String> listaKeys = Dados.keys;

    // if (listaKeys.isNotEmpty) {
    //   for (String key in listaKeys)
    //     Utils.MSG_Debug(strEspacos + "\tDados[" + key + "]=" + Dados[key]!);
    // }
  }

  //----------------------------------------
  String ToString(int N) {
    String strEspacos = Utils.CriarEspacos(N, "--");
    String RES = strEspacos + "ObjectoGeral: " + NomeObjecto!;
    Iterable<String> listaKeys = Dados.keys;
    for (String key in listaKeys)
      RES += strEspacos + "\tDados[" + key + "]=" + Dados[key]!;
    return RES;
  }
//----------------------------------------
}
