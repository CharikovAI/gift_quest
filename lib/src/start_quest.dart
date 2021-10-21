
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'qr_scanner.dart';
import 'quest.dart';

class LoadQuest extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => LoadQuestState();
}

class LoadQuestState extends State<LoadQuest> {

  TextEditingController codeController = TextEditingController();

  void _scanQR(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanner()),
    );

    if (result != null && result != []) {
      setState(() {
        codeController = TextEditingController(text: result);
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
                  labelText: AppLocalizations.of(context)!.question + '*',
                ),
                maxLines: 1,
              )
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<Data>(context, listen: false).setStoredQuestId(codeController.text);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => Quest(),
                ), (route) => false);
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