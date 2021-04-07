import 'package:app_client/src/features/chat/chat_page.dart';
import 'package:app_client/src/features/home/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        backgroundColor: Color(0XFF162447),
        scaffoldBackgroundColor: Color(0XFF162447),
        primaryColor: Color(0XFF1f4068),
        accentColor: Colors.orange,
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        'chat': (context) {
          final args = ModalRoute.of(context).settings.arguments as Map;
          return ChatPage(chatData: args['chatData']);
        }
      },
    );
  }
}
