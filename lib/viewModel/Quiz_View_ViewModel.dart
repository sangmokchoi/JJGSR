
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../extensions.dart';
import '../model/Quiz.dart';

class QuizViewViewModel extends ChangeNotifier {

  Timer? timer;

  double currentValue = 0.0;
  PageController quizVmPageController = PageController();

  final Box<int> secondsBox = Hive.box<int>('seconds');
  Future updateSeconds(double seconds) async {
    secondsBox.put('seconds', seconds.toInt());
  }
  double seconds = 30.0;

  Future addCurrentValue() async {
    currentValue += 1.0;
    notifyListeners();
  }
  Future resetCurrentValue() async {
    currentValue = 0.0;
    notifyListeners();
  }
  Future maximizeCurrentValue() async {
    currentValue = seconds;
    notifyListeners();
  }
  Future changeSeconds(int value) async {
    seconds = value.toDouble();
    await updateSeconds(seconds);
    notifyListeners();
  }

  int choicesBtnNum = -1;
  Future changeChoicesBtnNum(int value) async {
    choicesBtnNum = value;
    notifyListeners();
  }
  Future resetChoicesBtnNum() async {
    choicesBtnNum = -1;
    notifyListeners();
  }

  bool isChoiceDone = false;
  Future trueIsChoiceDone() async {
    isChoiceDone = true;
    notifyListeners();
  }
  Future resetIsChoiceDone() async {
    isChoiceDone = false;
    notifyListeners();
  }

  bool get isLastPage {
    return quizVmPageController.page?.toInt() == (quizVmPageController.positions.isNotEmpty ? quizVmPageController.positions.first.maxScrollExtent.toInt() : 0) / quizVmPageController.position.viewportDimension.toInt();
  }

  void startTimer(BuildContext context) {
    // 기존 타이머가 있으면 취소
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      scrollPage(context);
    });
  }

  void scrollPage(BuildContext context) async {
    addCurrentValue();

    if (currentValue >= seconds) {
      resetCurrentValue(); // 10초 이상이 되면 다시 0으로 초기화

      if (isLastPage) {
        timer!.cancel();
        Extensions().endQuizAlert(context);
      } else {
        quizVmPageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  final Box<Quiz> quizBox = Hive.box<Quiz>('quizzes');
  Future updateQuizStatus(Quiz quiz, int status) async {
    quiz.status = status;

    final Quiz _statusUpdated = quiz;
    quizBox.put(_statusUpdated.id, _statusUpdated);

  }


}