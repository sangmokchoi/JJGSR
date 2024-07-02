
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

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

  void sendToStore(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('알림'),
            content: const Text('스토어로 이동합니다'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  final appId =
                  Platform.isAndroid ? 'com.app.JJGSR' : '6504901441';

                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "https://play.google.com/store/apps/details?id=$appId"
                        : "https://apps.apple.com/app/id$appId",
                  );

                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text('스토어로 이동', style: TextStyle(color: Colors.blue),),
              ),
            ],
          ),
    );
  }
  void sendToStoreForUpdate(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('최신 앱 버전이 아니에요'),
            content: const Text('스토어에서 최신 버전으로 업데이트 해주세요'),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  final appId =
                  Platform.isAndroid ? 'com.app.JJGSR' : '6504566336';

                  final url = Uri.parse(
                    Platform.isAndroid
                        ? "https://play.google.com/store/apps/details?id=$appId"
                        : "https://apps.apple.com/app/id$appId",
                  );

                  launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: const Text('스토어로 이동', style: TextStyle(color: Colors.blue),),
              ),
            ],
          ),
    );
  }


}