
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'qr_scanner.dart';
import 'quest.dart';
import 'models/data.dart';

class LoadQuest extends StatefulWidget {
  const LoadQuest({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => LoadQuestState();
}

class LoadQuestState extends State<LoadQuest> {

  bool inputValidator = true;

  TextEditingController codeController = TextEditingController();

  void _scanQR(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QRScanner()),
    );

    if (result != null && result != []) {
      setState(() {
        codeController = TextEditingController(text: result);
      });
    }
  }

  void _validateInput() {
    if (codeController.text.isEmpty) {
      setState(() {
        inputValidator = false;
      });
    }
    else {
      setState(() {
        inputValidator = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.uploadQuest)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.insertCode),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: codeController,
                autofocus: false,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.questId + '*',
                  labelStyle: (inputValidator) ? const TextStyle(color:Colors.grey) : const TextStyle(color:Colors.red),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: inputValidator ? Colors.blue : Colors.red),
                  ),
                ),
                maxLines: 1,
              )
            ),
            ElevatedButton(
              onPressed: () {
                _validateInput();
                if (inputValidator) {
                  Provider.of<Data>(context, listen: false).setStoredQuestId(codeController.text);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const Quest()));
                }
              }, 
              child: Text(AppLocalizations.of(context)!.startMyQuest)
            )
          ],
      ),),
      floatingActionButton: FloatingActionButton(
              onPressed: () => _scanQR(context),
              child: const Icon(Icons.qr_code_scanner),
            )
    );
  }
}