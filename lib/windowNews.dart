import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_text_indicator/scrollable_text_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart' as xml;

import 'common/Management.dart';
import 'common/Utils.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowNews extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowNews(this.Ref_Management) {
    windowTitle = "News Window";
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
    return State_windowNews(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowNews extends State<windowNews> {
  List<Map<String, String>> news = [];

  Future<void> _loadXMLData() async {
    final newsXML =
        await Ref_Window.Ref_Management.GetDefinicao("NOTICIAS", "NOTICIAS ??");

    // Print the XML data to the console to check if it's loaded correctly.
    print("XML Data: $newsXML");

    if (newsXML != null) {
      final document = xml.XmlDocument.parse(newsXML);
      final rss = document.findElements('rss').first;
      final channel = rss.findElements('channel').first;
      final items = channel.findElements('item');

      final itemList = <Map<String, String>>[];

      for (final item in items) {
        final link = item.findElements('link').first.text;
        final title = item.findElements('title').first.text;
        final description = item.findElements('description').first.text;
        final pubDate = item.findElements('pubDate').first.text;

        itemList.add({
          'title': title,
          'description': description,
          'pubDate': pubDate,
          'link': link,
        });
      }

      setState(() {
        news = itemList;
      });
    }
  }

  // Function to load and parse XML data
  /*void _loadData() async {
    final temporaryList = [];


    // Code for parsing XML data.
    final document = xml.XmlDocument.parse(noticiasXml); //xml.XmlDocument.parse(Text( Ref_Janela.Ref_Gestao.GetDefinicao("NOTICIAS", "NOTICIAS ??")) as String);
    final channelsNode = document.findElements('rss').first;
    final channels = channelsNode.findElements('channel').first;
    final items = channels.findElements('item');
    for (final item in items) {
      final noticiaTitle = item.findElements('title').first;
      final noticiaDescription = item.findElements('description').first;
      temporaryList.add({'title': noticiaTitle, 'description': noticiaDescription});
    }

    setState(() {
      _noticias = temporaryList;
    });
  }*/

  final windowNews Ref_Window;
  String Nome_Classe = "";

  //--------------
  State_windowNews(this.Ref_Window) : super() {
    Nome_Classe = "Estado_JanelaGeral";
    Utils.MSG_Debug("$Nome_Classe: createState");
  }

  //--------------
  @override
  void dispose() {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$Nome_Classe:dispose");
  }

  //--------------
  @override
  void deactivate() {
    Utils.MSG_Debug("$Nome_Classe:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("$Nome_Classe: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$Nome_Classe: initState");
    super.initState();
    _loadXMLData();
  }

  void NavigateTo_New_Window(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => windowNews(Ref_Window.Ref_Management)));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$Nome_Classe: build");
    /*
    return Container(
        height: 40.0,
        child: TextButton(
        onPressed: () async {
            UteisFlutter.MSG("Carregou no botão");
            Navegar_Nova_Janela(context);
         },
          child: Text("Botão"),
    ),
    );*/
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Nome_Classe),
      ),
      body: news.isNotEmpty
          ? ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Colors.teal.shade100,
                  elevation: 5,
                  child: ListTile(
                    title: Text(news[index][
                            Ref_Window.Ref_Management.GetDefinicao(
                                "JANELA_NOTICIAS_TITLE", "TITLE ??")] ??
                        Ref_Window.Ref_Management.GetDefinicao(
                            "JANELA_NOTICIAS_NOTITLE", "TITLE ??")),
                    subtitle: Column(
                      children: [
                        Text(news[index][Ref_Window.Ref_Management.GetDefinicao(
                                "JANELA_NOTICIAS_PUBDATE", "PUBDATE ??")] ??
                            Ref_Window.Ref_Management.GetDefinicao(
                                "JANELA_NOTICIAS_NOPUBDATE", "PUBDATE ??")),
                        Text(news[index][Ref_Window.Ref_Management.GetDefinicao(
                                "JANELA_NOTICIAS_DESCRIPTION",
                                "DESCRIPTION ??")] ??
                            Ref_Window.Ref_Management.GetDefinicao(
                                "JANELA_NOTICIAS_NODESCRIPTION",
                                "DESCRIPTION ??")),
                        //Text(noticias[index]['link'] ?? 'No link'),
                      ],
                    ),
                    onLongPress: () {
                      UtilsFlutter.MSG("Estas a pressionar-me! ACCAO: NADA");
                    },
                    onTap: () async {
                      UtilsFlutter.MSG("Picaste-me! ACCAO: LINK");
                      var url = Uri.parse(news[index]['link'] ?? 'No link');
                      await launchUrl(url);
                    }, // Handle your onTap here.
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
    /*Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: ListView.builder(
            itemBuilder: (context, index) => Card(
              key: ValueKey(_noticias[index]['title']),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              color: Colors.teal.shade100,
              elevation: 5,
              child: ListTile(
                title: Text(_noticias[index]['title']),
                subtitle: Text("Attendance: ${_noticias[index]['description']}%"),
              ),
            ),
            itemCount: _noticias.length,
          ),
        ),
      );*/
  }
//--------------
//--------------
//--------------
}
