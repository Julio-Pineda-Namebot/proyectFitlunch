import 'package:flutter/material.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final List<types.Message> _messages = [];
  late OpenAI _openAI;
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot', firstName: 'AI Bot');
  final List<Map<String, dynamic>> _mensajesDeContexto = [];

  @override
  void initState() {
    super.initState();
    _openAI = OpenAI.instance.build(
      token: '',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 6)),
    );
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El mensaje no puede estar vacío")),
      );
      return;
    }

    final input = _controller.text.trim();
    final userMessage = types.TextMessage(
      author: _user,
      id: const Uuid().v4(),
      text: input,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, userMessage);
    });


    _mensajesDeContexto.insert(0, {
      'role': 'user',
      'content': input,
    });

    _mensajesDeContexto.removeWhere((mensaje) =>
        mensaje['content'].toString().contains('palabra clave irrelevante'));

    final request = ChatCompleteText(
      messages: [
      {
        'role': 'system',
        'content': 'Eres un asistente enfocado exclusivamente en comida saludable. Proporciona respuestas detalladas y útiles solo dentro de este contexto.',
      },
      ..._mensajesDeContexto,
      ],
      maxToken: 200,
      model: Gpt4ChatModel(),
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      final botResponse = response?.choices.first.message?.content ?? 'Error en respuesta';
      final botMessage = types.TextMessage(
        author: _bot,
        id: const Uuid().v4(),
        text: botResponse,
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      final errorMessage = types.TextMessage(
        author: _bot,
        id: const Uuid().v4(),
        text: "Error: $e",
        createdAt: DateTime.now().toUtc().millisecondsSinceEpoch,
      );

      setState(() {
        _messages.insert(0, errorMessage);
      });
    } finally {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitlunch Assistant', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2BC155),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: (message) {
                _controller.text = message.text;
                _sendMessage();
              },
              user: _user,
              showUserAvatars: true,
              inputOptions: const InputOptions(
                inputClearMode: InputClearMode.always,
                sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                autocorrect: true,
                enabled: true,
              ),
              theme: const DefaultChatTheme(
                primaryColor: Color(0xFF2BC155),
                inputBorderRadius: BorderRadius.all(Radius.circular(20)),
                inputElevation: 2.0,
                inputPadding: EdgeInsets.all(2),
                inputMargin: EdgeInsets.all(10),
                inputTextColor: Color.fromARGB(255, 0, 0, 0),
                inputTextStyle: TextStyle(fontSize: 16),
                sendButtonIcon: Icon(Icons.send, color: Color.fromARGB(255, 0, 0, 0)),
                sendButtonMargin: EdgeInsets.all(4),
                sentMessageBodyTextStyle: TextStyle(color: Colors.white),
                receivedMessageBodyTextStyle: TextStyle(color: Colors.black),
                inputBackgroundColor: Color.fromARGB(255, 224, 224, 224)
              ),
              avatarBuilder: (user) {
                if (user.id == 'bot') {
                  return const CircleAvatar(
                    backgroundImage: AssetImage('assets/splash_green2.png'),
                  );
                }
                return const CircleAvatar(
                  child: Icon(Icons.person),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}