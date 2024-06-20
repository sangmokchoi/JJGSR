
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
            title: const Text('알림'),
            content: const Text('아직 해당 카테고리 문제를 준비중입니다'),
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

}