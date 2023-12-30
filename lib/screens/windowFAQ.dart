import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ubi/common/appTheme.dart';

import '../common/Drawer.dart';
import '../common/Management.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';

class windowFAQ extends StatefulWidget {
  final Management Ref_Management;

  windowFAQ(this.Ref_Management);

  //--------------
  Future<void> Load() async {}

  @override
  _windowFAQState createState() => _windowFAQState(this);
}

class _windowFAQState extends State<windowFAQ> {
  final windowFAQ Ref_Window;
  String className = "";

  //--------------
  _windowFAQState(this.Ref_Window) : super() {
    className = "State_windowGeneral";
    //Utils.MSG_Debug("$className: createState");
  }

  Widget _buildFAQSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
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
              pergunta:
                  "Existe algum programa de fidelidade ou descontos disponíveis?",
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

  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home:Scaffold(
          drawer: CustomDrawer(Ref_Window.Ref_Management),
          appBar: AppBar(
            title: const Text("FeedBack"),
          ),
          body: (_buildFAQSection()),

        )
=======
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
            theme: provider.currentTheme,
            home: Scaffold(
              //drawer: CustomDrawer(Ref_Window.Ref_Management, Ref_Window.),
              appBar: AppBar(
                title: const Text("FeedBack"),
              ),
              body: (_buildFAQSection()),
            ));
      },
>>>>>>> Stashed changes
    );
  }
}
