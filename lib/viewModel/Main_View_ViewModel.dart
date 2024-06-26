import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../dataSource/local/local_quiz.dart';
import '../dataSource/remote/fireStore.dart';
import '../model/Quiz.dart';
import '../model/QuizTitle.dart';
import 'Quiz_View_ViewModel.dart';

class MainViewViewModel extends ChangeNotifier {
  int categoryNum = 0;
  int orderBtnNum = 0;

  List<String> categoryBtnStringList = [
    "toeic",
    "한국사",
    "한국어"
  ]; //, "정보처리기사", "공인중개사"];
  List<String> orderBtnStringList = ["전체", "O", "X", "PASS"];

  Future changeCategoryBtnNum(int value) async {
    categoryNum = value;
    notifyListeners();
  }

  Future changeOrderBtnNum(int value) async {
    orderBtnNum = value;
    notifyListeners();
  }

  final PageController pageController = PageController();

  // 문서 배열을 재정렬하는 함수
  Future<List<Quiz>> reorderDocuments(List<Quiz> documents, int index) async {
    //print("documents.length: ${documents.length}");
    //print("index: $index");
    if (index != -1) {
      final doc = documents.removeAt(index);
      documents.shuffle();
      documents.insert(0, doc);
    }
    return documents;
  }

  void scrollToBottom(int itemCount) {
    // pageController.animateToPage(
    //   itemCount - 1,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.linear,
    // );
    // pageController.animateTo(
    //   pageController.offset - 100,
    //   duration: Duration(milliseconds: 500),
    //   curve: Curves.easeInOut,
    // );
  }

  int stringToRandomInt(String input, int limit) {
    // 문자열을 바이트 배열로 변환
    List<int> bytes = utf8.encode(input);

    // 바이트 배열을 해시 값으로 변환 (여기서는 간단히 XOR를 사용)
    int hash = 0;
    for (int byte in bytes) {
      hash = (hash + byte) & 0xFFFFFFFF; // 해시 값이 음수가 되지 않도록 처리
    }

    // 해시 값을 기반으로 랜덤 생성기 초기화
    Random random = Random(hash);

    // 0부터 9까지의 랜덤 정수 생성
    int randomInt = random.nextInt(limit);

    return randomInt;
  }

  Color colorGenerator(String value) {

    List<Color> colors = [
      Color(0xFFF6D98B), // Apricot
      Color(0xDDAFBFFD), // Puppleberry (alpha value in hex)
      Color(0xFFF2E500), // Mango
      Color(0xFF005242), // Forest (alpha value in hex)
      Color(0xFF3ECDFE), // Cerulean (alpha value in hex)
      Color(0xFFFF8080), // Strawberry (alpha value in hex)
      Color(0xFFFE7A36), // Orange
      Color(0xFFBF313F), // Brick
      Color(0xFFA0E9FF), // Winter
      Color(0xFFA7D397), // Olive
    ];

    int randomInt = stringToRandomInt(value, colors.length); //

    return colors[randomInt];
  }

  final QuizTitle _quizTitle = QuizTitle();

  String titleGenerator(String value) {

    List<String> _sentences = _quizTitle.sentences;
    int randomInt = stringToRandomInt(value, _sentences.length);

    return _sentences[randomInt];
  }

  final FirestoreService _firestoreService = FirestoreService();
  final LocalQuiz _localQuiz = LocalQuiz();

  MainViewViewModel() {
    fetchQuizzes();
  }

  Future<List<Quiz>>? futureQuizzes;

  Future<void> fetchQuizzes() async {
    futureQuizzes = mainVmMergedQuizzes(categoryBtnStringList[categoryNum], _firestoreService.fixedLimit);
    notifyListeners();
  }

  Future<void> refreshQuizzes() async {
    final _numOfDocs = await updateNumOfDocs(_firestoreService.fixedLimit);
    futureQuizzes = mainVmMergedQuizzes(categoryBtnStringList[categoryNum], _numOfDocs);
    notifyListeners();
  }

  List<Quiz> totalQuizList = [];

  Future<List<Quiz>> mainVmMergedQuizzes(
      String collectionPath, int limit) async {

    List<Quiz> localQuizList = await _localQuiz.loadAllQuizzes() as List<Quiz>;
    List<Quiz> firestoreQuizList = await _firestoreService
        .getLimitedDocuments(collectionPath, limit);
    List<String> localQuizIds = localQuizList.map((quiz) => quiz.id).toList();

    // _localQuiz.localQuizList 안에 있는 id와 동일한 것이 있는지 확인하여 추가하지 않음
    List<Quiz> filteredQuizzes = firestoreQuizList
        .where((quiz) => !localQuizIds.contains(quiz.id))
        .toList();
    debugPrint("filteredQuizzes: $filteredQuizzes");
    await saveQuizzesToHive(filteredQuizzes);

    // 합칠 리스트 생성
    List<Quiz> mergedQuizzes = [];

    mergedQuizzes.addAll(localQuizList);
    mergedQuizzes.addAll(filteredQuizzes);
    mergedQuizzes = mergedQuizzes.reversed.toList();

    totalQuizList = mergedQuizzes;

    return totalQuizList;
  }

  final Box<Quiz> quizBox = Hive.box<Quiz>('quizzes');

  Future saveQuizzesToHive(List<Quiz> quizzes) async {
    for (var quiz in quizzes) {
      quizBox.put(quiz.id, quiz); // Hive에 저장
    }
  }

  int numOfDocs = 0;

  Future<int> updateNumOfDocs(int fixedLimit) async {
    numOfDocs = totalQuizList.length + fixedLimit;
    return numOfDocs;
  }

  void mainViewShowDialog(BuildContext context) {
    final List<int> secondsOptions =
    List.generate(12, (index) => (index + 1) * 5);

    int _index = -1;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300, // 높이를 늘려서 텍스트와 피커를 모두 포함할 수 있게 합니다.
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Material(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            '확인', // 원하는 텍스트를 여기에 추가합니다.
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.transparent
                            ),
                          ),
                        ),
                        Text('문제 타이머', style: TextStyle(
                            fontSize: 18,
                        ),),
                        GestureDetector(
                          onTap: (){
                            Provider.of<QuizViewViewModel>(context, listen: false)
                                .changeSeconds(secondsOptions[_index]);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: Text(
                              '확인', // 원하는 텍스트를 여기에 추가합니다.
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),

                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      _index = index;
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: secondsOptions.indexOf(
                            Provider.of<QuizViewViewModel>(context, listen: false)
                                .seconds
                                .toInt())),
                    children: secondsOptions.map((int seconds) {
                      return Center(
                        child: Text(
                          '$seconds 초',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
