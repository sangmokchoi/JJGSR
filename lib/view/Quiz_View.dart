import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jjgsr/viewModel/Quiz_View_ViewModel.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';
import '../extensions.dart';
import '../model/test_examples.dart';

class QuizView extends StatelessWidget {
  Future<void> resetVm(QuizViewViewModel vm) async {
    await vm.resetCurrentValue();
    await vm.resetChoicesBtnNum();
    await vm.resetIsChoiceDone();
  }

  @override
  Widget build(BuildContext context) {
    final TestExamples args =
        ModalRoute.of(context)!.settings.arguments as TestExamples;

    return Consumer<QuizViewViewModel>(builder: (context, vm, child) {
      return Scaffold(
          appBar: AppBar(
            leading: CupertinoNavigationBarBackButton(
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
                      scrollDirection: Axis.vertical,
                      onPageChanged: (_) async {
                        await resetVm(vm);
                      },
                      controller: vm.pageController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'Title: ${args.title}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: kOrangeColor,
                                ),
                              ),
                              Text(
                                'Question: ${args.question}',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height / 2,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: args.choices.length,
                                  itemBuilder: (context, index) {
                                    final data = args.choices[index];
                                    Color _choiceColor = Colors.white;

                                    if (vm.isChoiceDone) {
                                      if (data == args.answer) {
                                        _choiceColor = kCorrectColor;
                                      } else if (vm.choicesBtnNum == index) {
                                        _choiceColor = kWrongColor;
                                      }
                                    }

                                    return GestureDetector(
                                      onTap: () async {
                                        await vm.changeChoicesBtnNum(index);
                                        await vm.trueIsChoiceDone();
                                        Future.delayed(
                                                Duration(milliseconds: 500))
                                            .then((value) {
                                          vm.maximizeCurrentValue();
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.all(8.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: _choiceColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              width: 5.0,
                                              color: (Theme.of(context).brightness == Brightness.light) ?
                                              Colors.black :
                                              Colors.grey
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              blurRadius: 5,
                                              offset: Offset(0, 0.5),
                                            ),
                                          ],
                                        ),
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${index + 1}) ',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor), // 파란색으로 설정
                                              ),
                                              TextSpan(
                                                text: data,
                                                style: TextStyle(
                                                    color:
                                                        Colors.black), // 기본 색상
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(
                                              overflow: TextOverflow.fade,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ));
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
  final int _totalPages = 3;

  @override
  void initState() {
    super.initState();
    widget.vm.startTimer(context, _totalPages);
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
        valueColor: AlwaysStoppedAnimation<Color>(kOrangeColor),
      ),
    );
  }
}
