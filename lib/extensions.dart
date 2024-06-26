
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Extensions {

  void endQuizAlert(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('알림'),
            content: const Text('더 이상 불러올 수 있는 문제가 없습니다'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  void notSupportApology(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('곧 찍신강림에서 만나요!'),
            content: const Text('문제를 준비 중이니 조금만 기다려주세요'),
            // 빠른 시일 내로 준비하겠습니다
            // 조만간 출시 예정이니 조금만 기다려주세요
            // 곧 찍신강림에서 만나요!
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인', style: TextStyle(color: Colors.blue),),
              ),
            ],
          ),
    );
  }

  // void _showDialog(Widget child) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => Container(
  //       height: 216,
  //       padding: const EdgeInsets.only(top: 6.0),
  //       // The bottom margin is provided to align the popup above the system
  //       // navigation bar.
  //       margin: EdgeInsets.only(
  //         bottom: MediaQuery.of(context).viewInsets.bottom,
  //       ),
  //       // Provide a background color for the popup.
  //       color: CupertinoColors.systemBackground.resolveFrom(context),
  //       // Use a SafeArea widget to avoid system overlaps.
  //       child: SafeArea(
  //         top: false,
  //         child: child,
  //       ),
  //     ),
  //   );
  // }

}