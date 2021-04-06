import 'package:app_client/src/features/chat/chat_page.dart';
import 'package:app_client/src/features/home/home_page.dart';
import 'package:app_client/src/features/shared/models/chat_model.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        'chat': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return ChatPage(chatData: args['chatData']);
        }
      },
    );
  }
}
