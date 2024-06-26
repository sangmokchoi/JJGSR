import 'dart:ui';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jjgsr/dataSource/remote/fireStore.dart';
import 'package:jjgsr/googleAnalytics.dart';
import 'package:jjgsr/extensions.dart';
import 'package:jjgsr/viewModel/Main_View_ViewModel.dart';
import 'package:jjgsr/viewModel/Quiz_View_ViewModel.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';
import '../main.dart';
import '../model/Quiz.dart';

class MainView extends StatelessWidget {
  // 싱글톤 FirestoreService 인스턴스 사용
  final FirestoreService _firestoreService = FirestoreService();
  bool _renderCompleteState = false;

  double _width = 80;
  double _height = 45;

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewViewModel>(builder: (context, vm, child) {
      return SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 찍신강림 타이틀
                Container(
                  padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '찍신강림',
                        style: TextStyle(
                            fontFamily: 'Jua',
                            fontWeight: FontWeight.w500,
                            fontSize: 32.0,
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? kMainColor
                                : Theme.of(context).colorScheme.onBackground),
                        textAlign: TextAlign.start,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                              actions: <CupertinoActionSheetAction>[
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    vm.mainViewShowDialog(
                                        navigatorKey.currentContext!);
                                  },
                                  child: Text(
                                    '문제 타이머: ${Provider.of<QuizViewViewModel>(context, listen: false).seconds.toInt()}초',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '이용약관',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '개인정보 처리방침',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).pushNamed(
                                        "/OssView");
                                  },
                                  child: const Text(
                                    '오픈소스 라이센스',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('뒤로'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                isDestructiveAction: true,
                              ),
                            ),
                          );
                        },
                        child: Icon(Icons.more_vert),
                      )
                    ],
                  ),
                ),
                // 카테고리 메뉴
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: kInputLineColor.withOpacity(0.3), width: 1),
                    ),
                  ),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          //itemCount: data.length,
                          itemCount: vm.categoryBtnStringList.length,
                          itemBuilder: (context, index) {
                            EdgeInsetsGeometry _padding =
                                EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0);
                            EdgeInsetsGeometry _margin =
                                EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 0.0);

                            if (index == 0) {
                              _margin =
                                  EdgeInsets.fromLTRB(25.0, 8.0, 10.0, 0.0);
                            } else if (index ==
                                vm.categoryBtnStringList.length - 1) {
                              _margin =
                                  EdgeInsets.fromLTRB(10.0, 8.0, 20.0, 0.0);
                            }

                            final _data =
                                vm.categoryBtnStringList[index].toUpperCase();

                            return GestureDetector(
                              onTap: () async {
                                await GoogleAnalytics()
                                    .clickedCategoryEvent(_data);
                                vm.mainVmMergedQuizzes(
                                    vm.categoryBtnStringList[vm.categoryNum],
                                    _firestoreService.fixedLimit);

                                if (index == 0) {
                                  await vm.changeCategoryBtnNum(index);
                                } else {
                                  await vm.changeCategoryBtnNum(index);
                                  Extensions().notSupportApology(context);
                                }

                                await vm.changeOrderBtnNum(
                                    0); // 다른 카테고리를 클릭하면, '전체'로 오게끔 설정
                              },
                              child: Container(
                                padding: _padding,
                                margin: _margin,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: (vm.categoryNum == index)
                                            ? kOrangeColor
                                            : Colors.transparent,
                                        width: 2),
                                  ),
                                  //color: Colors.blue,
                                ),
                                child: Text(
                                  '${_data}',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: (vm.categoryNum == index)
                                          ? kOrangeColor
                                          : kInputLineColor,
                                      fontWeight: FontWeight.bold,
                                      textBaseline: TextBaseline.ideographic),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // 정렬 메뉴
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 20.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      SizedBox(
                        height: _height,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: vm.orderBtnStringList.length,
                          //itemCount: 10,
                          itemBuilder: (context, index) {
                            EdgeInsetsGeometry _padding = EdgeInsets.all(8.0);
                            EdgeInsetsGeometry _margin = EdgeInsets.all(5.0);

                            if (index == 0) {
                              _margin =
                                  EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0);
                            } else if (index == 10 - 1) {
                              _margin =
                                  EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0);
                            }

                            final _data = vm.orderBtnStringList[index];

                            return GestureDetector(
                              onTap: () async {
                                await vm.changeOrderBtnNum(index);
                              },
                              child: Container(
                                width: 70,
                                padding: _padding,
                                margin: _margin,
                                decoration: BoxDecoration(
                                  color: (vm.orderBtnNum == index)
                                      ? kOrangeColor
                                      // ? (Theme.of(context).brightness ==
                                      // Brightness.light
                                      // ? kMainColor
                                      // : kOrangeColor)
                                      : kInputLineColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      //spreadRadius: 5,
                                      blurRadius: 1,
                                      offset: Offset(0, 0.5),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${_data}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
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
                ),
                // 그리드 뷰
                Expanded(
                  child: FutureBuilder<List<Quiz>>(
                      future: vm.futureQuizzes,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'mainVmMergedQuizzes Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No data found'));
                        }

                        Iterable<Quiz> documents = snapshot.data!;
                        // 카테고리별 분류
                        documents = documents.where((element) =>
                            element.category ==
                            vm.categoryBtnStringList[vm.categoryNum]);
                        // 정렬별 분류
                        switch (vm.orderBtnNum) {
                          case 1:
                            documents = documents
                                .where((element) => element.status == 1);
                            break;
                          case 2:
                            documents = documents
                                .where((element) => element.status == -1);
                            break;
                          case 3:
                            documents = documents
                                .where((element) => element.status == null);
                            break;
                        }

                        if (documents.isEmpty) {
                          return Center(child: Text('No Data Found'));
                        } else {
                          return CustomRefreshIndicator(
                            onRefresh: () async {
                              await vm.refreshQuizzes();
                            },
                            durations: const RefreshIndicatorDurations(
                              completeDuration: Duration(seconds: 1),
                            ),
                            onStateChanged: (change) {
                              if (change.didChange(
                                  to: IndicatorState.complete)) {
                                _renderCompleteState = true;
                              } else if (change.didChange(
                                  to: IndicatorState.idle)) {
                                _renderCompleteState = false;
                              }
                            },
                            trigger: IndicatorTrigger.leadingEdge,
                            trailingScrollIndicatorVisible: true,
                            leadingScrollIndicatorVisible: false,
                            builder: (BuildContext context, Widget child,
                                IndicatorController controller) {
                              final height = 100.0;
                              final triggerDistance = 30.0; // 트리거할 당김 거리

                              final dy = controller.value.clamp(0.0, 1.0) *
                                  (height - triggerDistance);

                              return Stack(
                                children: [
                                  Transform.translate(
                                    offset: Offset(0.0, dy),
                                    child: child,
                                  ),
                                  Positioned(
                                    top: -height + triggerDistance,
                                    left: 0,
                                    right: 0,
                                    height: height,
                                    child: Container(
                                      transform: Matrix4.translationValues(
                                          0.0, dy, 0.0),
                                      padding:
                                          const EdgeInsets.only(bottom: 0.0),
                                      constraints:
                                          const BoxConstraints.expand(),
                                      child: Column(
                                        children: [
                                          Text(
                                            _renderCompleteState
                                                ? "불러오는 중"
                                                : "퀴즈를 더 불러오려면 당기세요",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? kMainColor
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground),
                                          ),
                                          if (_renderCompleteState)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              width: 16,
                                              height: 16,
                                              child: CupertinoActivityIndicator(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? kMainColor
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                              ),
                                            )
                                          else
                                            Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? kMainColor
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            child: CustomRefreshIndicator(
                              onRefresh: () async {
                                await vm.refreshQuizzes();
                              },
                              durations: const RefreshIndicatorDurations(
                                completeDuration: Duration(seconds: 1),
                              ),
                              onStateChanged: (change) {
                                if (change.didChange(
                                    to: IndicatorState.complete)) {
                                  _renderCompleteState = true;
                                } else if (change.didChange(
                                    to: IndicatorState.idle)) {
                                  _renderCompleteState = false;
                                }
                              },
                              trigger: IndicatorTrigger.trailingEdge,
                              trailingScrollIndicatorVisible: false,
                              leadingScrollIndicatorVisible: true,
                              builder: (BuildContext context, Widget child,
                                  IndicatorController controller) {
                                final height = 100.0;
                                final triggerDistance = 35.0;
                                final dy = controller.value.clamp(0.0, 1.25) *
                                    -(height - (height * 0.25));
                                return Stack(
                                  children: [
                                    Transform.translate(
                                      offset: Offset(0.0, dy),
                                      child: child,
                                    ),
                                    Positioned(
                                      bottom: -height + triggerDistance,
                                      //bottom: -height,
                                      left: 0,
                                      right: 0,
                                      height: height,
                                      child: Container(
                                        transform: Matrix4.translationValues(
                                            0.0, dy, 0.0),
                                        padding:
                                            const EdgeInsets.only(top: 30.0),
                                        constraints:
                                            const BoxConstraints.expand(),
                                        child: Column(
                                          children: [
                                            if (_renderCompleteState)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? kMainColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                ),
                                              )
                                            else
                                              Icon(
                                                Icons.keyboard_arrow_up,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? kMainColor
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                              ),
                                            Text(
                                              _renderCompleteState
                                                  ? "불러오는 중"
                                                  : "퀴즈를 더 불러오려면 당기세요",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? kMainColor
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onBackground),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              child: Container(
                                child: GridView.builder(
                                  itemCount: documents.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 0.5,
                                    crossAxisSpacing: 0.5,
                                    childAspectRatio: 1 / 1.75,
                                  ),
                                  itemBuilder: (context, index) {
                                    final document = documents.elementAt(index);
                                    return GestureDetector(
                                      onTap: () async {
                                        final _totalQuizList = vm.totalQuizList
                                            .toList(); // deepCopy

                                        await vm
                                            .reorderDocuments(
                                                _totalQuizList, index)
                                            .then((reorderedDocs) {
                                          Navigator.of(context).pushNamed(
                                              "/QuizView",
                                              arguments: reorderedDocs);
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: vm.colorGenerator(
                                                      document.id),
                                                  width: 3.0),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    document.first_category!,
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        color: kOrangeColor),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text(
                                                    vm.titleGenerator(
                                                        document.id),
                                                    style: TextStyle(
                                                        fontFamily: 'Jua',
                                                        fontSize: 24.0,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? kGreyColor
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .onBackground),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
