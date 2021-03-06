import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'intro.dart';
import 'models/data.dart';

class QuestCreated extends StatelessWidget {

  const QuestCreated(this.questId, {Key? key}) : super(key: key);

  final String questId;

  @override
  Widget build(BuildContext context) {
    Provider.of<Data>(context, listen: false).storeCreatedQuestId(questId);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.questCreated)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(AppLocalizations.of(context)!.saveQR,
            textAlign: TextAlign.center,
          ),
        ),
        QrImage(
          data: questId,
          version: QrVersions.auto,
          size: 320,
          gapless: false,
          errorStateBuilder: (cxt, err) {
            return Center(
              child: Text(
                err.toString(),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(questId),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: questId));
                final snackBar = SnackBar(
                  content: Text(AppLocalizations.of(context)!.copied),
                  action: SnackBarAction(
                    label: AppLocalizations.of(context)!.undo,
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, 
              icon: const Icon(Icons.copy)
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(AppLocalizations.of(context)!.pleaseSaveQR,
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<Data>(context, listen: false).deleteCreatedQuestId();
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) => const Intro(),
            ), (route) => false);
          },
          child: Text(AppLocalizations.of(context)!.iSaveCode)
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}