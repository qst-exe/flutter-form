import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final nameFieldController = TextEditingController();
    final emailFieldController = TextEditingController();
    final contentFieldController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'お名前',
              ),
              controller: nameFieldController,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'メールアドレス',
              ),
              controller: emailFieldController,
            ),
            TextFormField(
              minLines: 5,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'お問い合わせ内容',
              ),
              controller: contentFieldController,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () async {
                  final body = {
                    // TODO: Spearlyのページからform_version_idを取得します
                    'form_version_id': 0,
                    'fields': {
                      'name': nameFieldController.text,
                      'email': emailFieldController.text,
                      'content': contentFieldController.text
                    }
                  };
                  final jsonBody = jsonEncode(body);
                  final res = await http.post(
                      Uri.parse('https://api.spearly.com/form_answers'),
                      headers: {
                        // TODO: Spearlyのページからapiキーを取得します
                        'Authorization': 'Bearer apikey',
                        'Accept': 'application/vnd.spearly.v2+json',
                        'Content-Type': 'application/json'
                      },
                      body: jsonBody);

                  if (res.statusCode != 201) {
                    return;
                  }

                  await showDialog<void>(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text(
                          '送信成功',
                        ),
                        content: const Text(
                          'お問い合わせありがとうございます',
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text(
                              'OK',
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '送信',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
