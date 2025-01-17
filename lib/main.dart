import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jjgsr/extensions.dart';
import 'package:jjgsr/view/Oss_View.dart';
import 'dataSource/local/local_quiz.dart';
import 'dataSource/remote/remoteConfig.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjgsr/Constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:jjgsr/view/Main_View.dart';
import 'package:jjgsr/view/Quiz_View.dart';
import 'package:jjgsr/viewModel/Main_View_ViewModel.dart';
import 'package:jjgsr/viewModel/Quiz_View_ViewModel.dart';
import 'package:provider/provider.dart';

import 'model/Quiz.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
    debugPrint('crashlytics 사용가능');
  }

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();

  Hive.registerAdapter(QuizAdapter());
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  // Hive 데이터베이스에서 사용할 Box 열기
  await Hive.openBox<Quiz>('quizzes');
  await Hive.openBox<int>('seconds');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => MainViewViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => QuizViewViewModel(),
    ),
  ], child: MyApp(observer: observer,)));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {

  MyApp({required this.observer});

  FirebaseAnalyticsObserver observer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/MainView": (context) => MainView(),
        "/QuizView": (context) => QuizView(),
        "/OssView": (context) => OssView(),
      },
      navigatorKey: navigatorKey,
      navigatorObservers: [observer],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
        primaryColor: kMainColor,
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  final LocalQuiz _localQuiz = LocalQuiz();
  final RemoteConfig _remoteConfig = RemoteConfig();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _remoteConfig.remoteConfigFetchAndActivate().then((value) async {
        final bool isUpdateNeeded = await _remoteConfig.checkAppVersion() as bool;
        if (isUpdateNeeded) {
          Extensions().sendToStoreForUpdate(navigatorKey.currentContext!);
        }
      });

    });

    final secondsBox = Provider.of<QuizViewViewModel>(context, listen: false).secondsBox;
    super.initState();
    int? storedSeconds = secondsBox.get('seconds');

    debugPrint("storedSeconds: $storedSeconds");

    if (storedSeconds != null) {
      Provider.of<QuizViewViewModel>(context, listen: false).changeSeconds(storedSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
          future: _localQuiz.loadAllQuizzes(),
          builder: (context, snapshot) {

              return Stack(
                children: [
                  MainView(),
                  if (snapshot.connectionState == ConnectionState.waiting)
                  Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.transparent.withOpacity(0),
                        ),
                      ),
                      // 로딩 인디케이터
                      Center(
                        child: CupertinoActivityIndicator(
                            radius: 20.0, animating: true),
                      ),
                    ],
                  ),
                ],
              );

          }),
    );
  }
}
