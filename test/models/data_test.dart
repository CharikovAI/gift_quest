import 'package:test/test.dart';
import 'package:gift_quest/src/models/data.dart';

void main() {
  group('Testing Data class', () {
    var data = Data();

    test('A class should be initialized with empty values', () {
      expect(data.questId, isEmpty);
      expect(data.currentStep, equals(0));
      expect(data.createdQuestID, isEmpty);
    }); 
    test('A createdQuestId should be stored', () async {
      var createdQuestId = 'testId';
      await data.storeCreatedQuestId(createdQuestId);
      expect(data.createdQuestID, equals(createdQuestId));
      await data.deleteCreatedQuestId();
      expect(data.createdQuestID, isNull);
    });  
    test('An inserted questId should be stored', () async {
      var questId = 'testId';
      await data.setStoredQuestId(questId);
      expect(data.questId, equals(questId));
      expect(data.currentStep, equals(0));
    });
    test('The current step should be increased', () async {
      //var currentStep = data.currentStep!;
      await data.updateCurrentStep();
      expect(data.currentStep, equals(1));
    });  
    test('The questId should be unstored', () async {
      await data.deleteStoredQuestId();
      expect(data.questId, isNull);
      expect(data.currentStep, equals(0));
    });
  });
}