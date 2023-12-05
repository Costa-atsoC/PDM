import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../common/Management.dart';


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


  Widget _buildFAQSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 150,
        ),
        child: ListView(
          children: [
            _buildFAQItem(
              pergunta: "Como funciona a aplicação de boleias?",
              resposta:
              "A aplicação de boleias conecta condutores e passageiros para viagens compartilhadas. Os passageiros solicitam uma boleia e os condutores aceitam a solicitação para fornecer o serviço.",
            ),
            _buildFAQItem(
              pergunta: "Como posso solicitar uma boleia?",
              resposta:
              "Faça o download da aplicação, crie uma conta, insira o seu destino e solicite uma boleia. Um condutor disponível será atribuído a você.",
            ),
            _buildFAQItem(
              pergunta: "Como escolher o tipo de veículo?",
              resposta:
              "Na aplicação, você pode escolher entre diferentes tipos de veículos, como econômicos, premium ou veículos compartilhados, dependendo das suas necessidades e orçamento.",
            ),
            _buildFAQItem(
              pergunta: "Como é calculado o preço da boleia?",
              resposta:
              "O preço da boleia é calculado com base na distância, tempo estimado de viagem, tarifas base e quaisquer taxas adicionais. O valor total será exibido antes de confirmar a solicitação.",
            ),
            _buildFAQItem(
              pergunta: "Como posso pagar pela boleia?",
              resposta:
              "A maioria das aplicações de boleias permite pagamentos através de cartão de crédito, PayPal ou outros métodos de pagamento eletrônico diretamente na aplicação.",
            ),
            _buildFAQItem(
              pergunta: "Posso agendar uma boleia com antecedência?",
              resposta:
              "Algumas aplicações oferecem a opção de agendar boleias com antecedência. Verifique se a sua aplicação suporta essa funcionalidade.",
            ),
            _buildFAQItem(
              pergunta: "Como é feita a seleção de condutores?",
              resposta:
              "Os condutores são geralmente avaliados pelos passageiros após cada viagem. Os usuários podem ver a classificação média do condutor antes de aceitar uma boleia.",
            ),
            _buildFAQItem(
              pergunta: "O que devo fazer se perder a minha boleia?",
              resposta:
              "Entre em contato com o condutor através da aplicação. Além disso, algumas aplicações oferecem a opção de entrar em contato com o suporte ao cliente para assistência.",
            ),
            _buildFAQItem(
              pergunta: "Existe algum programa de fidelidade ou descontos disponíveis?",
              resposta:
              "Algumas aplicações oferecem programas de fidelidade ou descontos para usuários frequentes. Verifique as opções de recompensas na aplicação.",
            ),
            _buildFAQItem(
              pergunta: "Como posso relatar um problema durante a viagem?",
              resposta:
              "Se surgir algum problema durante a viagem, a maioria das aplicações oferece uma opção para relatar problemas. Isso geralmente é feito através do histórico de viagens na aplicação.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String pergunta, required String resposta}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pergunta,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          resposta,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildReportProblemSection() {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8.0),
            Text(
              "Please select the type of feedback",
              style: TextStyle(color: Color(0xffc5c5c5), fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ..._buildRadioItems([
              "Login trouble",
              "Phone number related",
              "Personal profile",
              "Post Interaction/Viewing",
              "Suggestions",
              "Other (Specify)", // Opção "Outros"
            ]),
            SizedBox(height: 20.0), // Adiciona espaçamento após os itens do radio
            buildFeedbackForm(),
            SizedBox(height: 10.0), // Adiciona espaçamento após o formulário de feedback
            buildNumberField(),
            SizedBox(height: 20.0), // Adiciona espaçamento antes do botão SUBMIT
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Lógica para processar o feedback selecionado
                      print("Selected Feedback Type: $selectedFeedbackType");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffe5e5e5),
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
          color: Colors.blue,
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
            Icon(Icons.check_circle,color: Colors.blue),
            SizedBox(width: 10.0),
            Text(title,style: TextStyle(fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            )
          ],
        )
    );
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
            itemBuilder: (context, _) => Icon(
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900], // Cor da AppBar
        title: const Text("FeedBack"),
      ),
      body: (_currentIndex == 0
          ? _buildFAQSection()
          : (_currentIndex == 1
          ? _buildReportProblemSection()
          : _buildRatingSection())),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue, // Cor da BottomNavigationBar
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'FAQ',
          ),
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
    );
  }
}