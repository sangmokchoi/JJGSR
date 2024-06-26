import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jjgsr/viewModel/Main_View_ViewModel.dart';
import 'package:jjgsr/viewModel/Quiz_View_ViewModel.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';
import '../dataSource/remote/fireStore.dart';
import '../model/Quiz.dart';

class QuizView extends StatelessWidget {
  Future<void> resetVm(QuizViewViewModel vm) async {
    await vm.resetCurrentValue();
    await vm.resetChoicesBtnNum();
    await vm.resetIsChoiceDone();
  }

  @override
  Widget build(BuildContext context) {
    final List<Quiz> documents =
        ModalRoute.of(context)!.settings.arguments as List<Quiz>;

    return Consumer<QuizViewViewModel>(builder: (context, vm, child) {
      return PopScope(
        onPopInvoked: (_) async {
          await resetVm(vm);
        },
        child: Scaffold(
            appBar: AppBar(
              leading: CupertinoNavigationBarBackButton(
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () async {
                  await resetVm(vm);
                  Navigator.pop(context);
                },
              ),
            ),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProgessWidget(vm: vm),
                  Expanded(
                      child: PageView.builder(
                    controller: vm.quizVmPageController,
                    scrollDirection: Axis.vertical,
                    itemCount: documents.length,
                    onPageChanged: (value) async {
                      await resetVm(vm);
                    },
                    itemBuilder: (context, pageIndex) {
                      final document = documents[pageIndex];

                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              Provider.of<MainViewViewModel>(context, listen: false).titleGenerator(
                                  document.id),
                              style: TextStyle(
                                fontFamily: 'Jua',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20.0,
                                  color: Theme.of(context).brightness ==
                                      Brightness.light
                                      ? kOrangeColor
                                      : Theme.of(context).colorScheme.onBackground
                              ),
                            ),
                            Text(
                              document.question,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 3,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: document.choices.length,
                                itemBuilder: (context, choiceIndex) {
                                  //print("main view document: ${document.id}"); // 문서 id

                                  final choice = document.choices[choiceIndex];
                                  Color _choiceColor = Colors.white;
                                  int status = 0;

                                  if (vm.isChoiceDone) {
                                    if (choice == document.answer) {
                                      _choiceColor = kCorrectColor;
                                    } else if (vm.choicesBtnNum == choiceIndex) {
                                      _choiceColor = kWrongColor;
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () async {
                                      if (choice == document.answer) {
                                        status = 1;
                                      } else {
                                        status = -1;
                                      }

                                      vm.updateQuizStatus(document, status);

                                      await vm.changeChoicesBtnNum(choiceIndex);
                                      await vm.trueIsChoiceDone();

                                      if (vm.timer!.isActive) {
                                        // 타이머가 작동하는 동안에만 실행됨
                                        Future.delayed(
                                                Duration(milliseconds: 250))
                                            .then((value) {
                                          vm.maximizeCurrentValue();
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.all(8.0),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15.0),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: _choiceColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        border: Border.all(
                                            width: 1.0, color: kGreyColor),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            blurRadius: 5,
                                            offset: Offset(0, 0.5),
                                          ),
                                        ],
                                      ),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '(${choiceIndex + 1})  ',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .primaryColor, // 파란색으로 설정
                                              ),
                                            ),
                                            TextSpan(
                                              text: choice,
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black), // 기본 색상
                                            ),
                                          ],
                                        ),
                                        style: TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )),
                  Icon(
                    Icons.keyboard_double_arrow_down,
                    color: Colors.grey,
                    size: 30,
                  )
                ],
              ),
            )),
      );
    });
  }
}

class ProgessWidget extends StatefulWidget {
  ProgessWidget({required this.vm});

  QuizViewViewModel vm;

  @override
  State<ProgessWidget> createState() => _ProgessWidgetState();
}

class _ProgessWidgetState extends State<ProgessWidget> {
  @override
  void initState() {
    super.initState();
    widget.vm.startTimer(context);
  }

  @override
  void dispose() {
    widget.vm.timer?.cancel(); // 페이지가 dispose될 때 타이머 해제
    //widget.vm.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: LinearProgressIndicator(
        value: widget.vm.currentValue / widget.vm.seconds,
        minHeight: 3.0,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(kGreyColor),
      ),
    );
  }
}
