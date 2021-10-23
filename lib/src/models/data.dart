import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Data extends ChangeNotifier {
  String? questId;
  int? currentStep;
  String? createdQuestID;

  Data() {
    init();
  }

  init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = prefs.getString('questId');
    createdQuestID = prefs.getString('createdQuestID');
    currentStep = prefs.getInt('currentStep');
    notifyListeners();
  }
  
  setStoredQuestId(String newQuestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = newQuestId;
    currentStep = 0;
    await prefs.setString('questId', newQuestId);
    await prefs.setInt('currentStep', 0);
    notifyListeners();
  }

  updateCurrentStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentStep', currentStep! + 1);
    currentStep = currentStep! + 1;
    notifyListeners();
  }

  deleteStoredQuestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    questId = null;
    currentStep = 0;
    await prefs.setString('questId', '');
    await prefs.setInt('currentStep', 0);
    notifyListeners();
  }

  storeCreatedQuestId(String questId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createdQuestID = questId;
    await prefs.setString('createdQuestID', questId);
    notifyListeners();
  }

  deleteCreatedQuestId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    createdQuestID = null;
    await prefs.setString('createdQuestID', '');
    notifyListeners();
  }
}
