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
      body: SingleChildScrollView(
        child: Container(
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
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: AssetImage(imageReference.dog),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Caramelo Chat',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellowAccent.shade700,
                ),
              ),
              SizedBox(height: 24.0),
              Divider(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Fulano',
                        labelText: 'Diga seu nome ao Caramelo',
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
                        labelText: 'Nome da casinha',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                      },
                      onChanged: (roomValue) => chatData.room = roomValue,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              visualDensity: VisualDensity.standard,
                            ),
                            child: Text(
                              'Entrar na sala',
                              style: TextStyle(color: Theme.of(context).backgroundColor),
                            ),
                            onPressed: validateForm,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
