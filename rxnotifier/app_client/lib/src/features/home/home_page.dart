import 'package:app_client/src/features/shared/models/chat_model.dart';
import 'package:app_client/src/features/shared/utils/image_reference_util.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ImageReferenceUtil imageReference = ImageReferenceUtil();
  ChatData chatData = ChatData(name: '', room: '');

  void validateForm() {
    if (_formKey.currentState!.validate()) {
      goToChatPage();
    }
  }

  void goToChatPage() {
    Navigator.pushNamed(
      context,
      'chat',
      arguments: {'chatData': chatData},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              child: CircleAvatar(
                backgroundImage: AssetImage(imageReference.dog),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ana Carolina',
                      labelText: 'Seu nome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                    },
                    onChanged: (nameValue) => chatData.name = nameValue,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Flutter',
                      labelText: 'Sala',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                    },
                    onChanged: (roomValue) => chatData.room = roomValue,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    child: Text('Entrar na sala'),
                    onPressed: validateForm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
