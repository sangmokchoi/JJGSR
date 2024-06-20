
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extensions.dart';

class QuizViewViewModel extends ChangeNotifier {

  Timer? timer;

  double currentValue = 0.0;
  PageController pageController = PageController();
  double seconds = 10.0;

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
    return pageController.page?.toInt() == (pageController.positions.isNotEmpty ? pageController.positions.first.maxScrollExtent.toInt() : 0) / pageController.position.viewportDimension.toInt();
  }


  void startTimer(BuildContext context, int totalPages) {
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
        pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

}