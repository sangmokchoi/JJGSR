
import 'package:hive/hive.dart';

import '../../model/Quiz.dart';

class LocalQuiz {

  // FirestoreService의 인스턴스를 저장할 정적 변수
  static final LocalQuiz _instance = LocalQuiz._internal();

  // 내부 생성자
  LocalQuiz._internal();

  // 공용 팩토리 생성자
  factory LocalQuiz() {
    return _instance;
  }

  List<Quiz> localQuizList = [];

  Future<List<Quiz>> loadAllQuizzes() async {
    // // Hive 초기화
    // await Hive.initFlutter();

    // Hive Box 열기
    var quizBox = await Hive.openBox<Quiz>('quizzes');

    // 모든 데이터 가져오기
    Iterable<dynamic> allQuizzes = quizBox.values;

    // Iterable을 리스트로 변환 (선택사항)
    List<Quiz> quizzes = allQuizzes.cast<Quiz>().toList();
    localQuizList = quizzes;

    // Hive Box 닫기
    //await quizBox.close();

    // Hive 종료
    //await Hive.close();

    // quizzes.forEach((quiz) {
    //   print('Quiz ID: ${quiz.id}, Question: ${quiz.question}');
    //   // 여기에 추가적인 데이터 처리 또는 출력 로직을 추가할 수 있습니다.
    // });

    return localQuizList;
  }

}