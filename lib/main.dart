import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jjgsr/Constants.dart';
import 'package:jjgsr/view/Main_View.dart';
import 'package:jjgsr/view/Quiz_View.dart';
import 'package:jjgsr/viewModel/Main_View_ViewModel.dart';
import 'package:jjgsr/viewModel/Quiz_View_ViewModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => MainViewViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => QuizViewViewModel(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/MainView": (context) => MainView(),
        "/QuizView": (context) => QuizView(),
      },
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: kMainColor),
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: MainView(),
    );
  }
}
