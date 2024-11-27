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

  @override
  void initState() {
    super.initState();
    _openAI = OpenAI.instance.build(
      token: 'TU_API_KEY', // Cambia esto por tu token
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

    final request = ChatCompleteText(
      messages: _messages.map((msg) {
        return {
          'role': msg.author.id == 'user' ? 'user' : 'assistant',
          'content': msg is types.TextMessage ? msg.text : '',
        };
      }).toList(),
      maxToken: 200,
      model: GptTurboChatModel(),
    );

    try {
      final response = await _openAI.onChatCompletion(request: request);
      final botResponse = response?.choices.first.message?.content ?? 'Error en respuesta';
      final botMessage = types.TextMessage(
        author: _bot,
        id: const Uuid().v4(),
        text: botResponse,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      final errorMessage = types.TextMessage(
        author: _bot,
        id: const Uuid().v4(),
        text: "Error: $e",
        createdAt: DateTime.now().millisecondsSinceEpoch,
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
        title: const Text('Fitlunch AI', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2BC155),
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
                inputTextColor: Color.fromARGB(255, 255, 255, 255),
                inputTextStyle: TextStyle(fontSize: 16),
                sendButtonIcon: Icon(Icons.send, color: Colors.white),
                sendButtonMargin: EdgeInsets.all(4),
                sentMessageBodyTextStyle: TextStyle(color: Colors.white),
                receivedMessageBodyTextStyle: TextStyle(color: Colors.black),
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