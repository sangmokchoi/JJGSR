
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainViewViewModel extends ChangeNotifier {

  int categoryNum = 0;
  int orderBtnNum = 0;

  List<String> categoryBtnStringList = ["TOEIC", "한국사", "한국어", "정보처리기사", "운전면허", "공인중개사"];
  List<String> orderBtnStringList = ["파트순", "O", "X", "PASS"];

  Future changeCategoryBtnNum(int value) async {
    categoryNum = value;
    notifyListeners();
  }
  Future changeOrderBtnNum(int value) async {
    orderBtnNum = value;
    notifyListeners();
  }

  final PageController pageController = PageController();

}