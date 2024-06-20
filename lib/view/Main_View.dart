import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jjgsr/extensions.dart';
import 'package:jjgsr/model/test_examples.dart';
import 'package:jjgsr/viewModel/Main_View_ViewModel.dart';
import 'package:provider/provider.dart';

import '../Constants.dart';

class MainView extends StatelessWidget {
  double _width = 80;
  double _height = 45;

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewViewModel>(builder: (context, vm, child) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 찍신강림 타이틀
            Container(
              padding: EdgeInsets.only(top: 5.0, left: 20.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '찍신강림',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32.0,
                        color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.start,
                  ),
                  GestureDetector(
                    onTap: (){
                      Extensions().notSupportApology(context);
                    },
                      child: Icon(CupertinoIcons.gear_alt_fill))
                ],
              ),
            ),
            // 카테고리 메뉴
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
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
                          _margin = EdgeInsets.fromLTRB(25.0, 8.0, 10.0, 0.0);
                        } else if (index ==
                            vm.categoryBtnStringList.length - 1) {
                          _margin = EdgeInsets.fromLTRB(10.0, 8.0, 20.0, 0.0);
                        }

                        final _data = vm.categoryBtnStringList[index];

                        return GestureDetector(
                          onTap: () async {
                            if (index == 0) {
                              await vm.changeCategoryBtnNum(index);
                            } else {
                              Extensions().notSupportApology(context);
                            }
                          },
                          child: Container(
                            padding: _padding,
                            margin: _margin,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: (vm.categoryNum == index)
                                        ? kOrangeColor
                                        : Colors.grey,
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
                                      : Colors.grey,
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
                          _margin = EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0);
                        } else if (index == 10 - 1) {
                          _margin = EdgeInsets.fromLTRB(5.0, 5.0, 20.0, 5.0);
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
                                  ? kMainColor
                                  : Colors.grey,
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
              child: PageView.builder(
                  controller: vm.pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: GridView.builder(
                          itemCount: data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0.5,
                            crossAxisSpacing: 0.5,
                            childAspectRatio: 1 / 1.75,
                          ),
                          itemBuilder: (context, index) {
                            final _data = data[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed("/QuizView", arguments: _data);
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _data.color ?? kMainColor,
                                          width: 3.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_data.title}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                            overflow: TextOverflow.fade),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }
}
