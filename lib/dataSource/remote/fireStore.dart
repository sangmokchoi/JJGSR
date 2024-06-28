import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../model/Quiz.dart';
import '../local/local_quiz.dart';

class FirestoreService {
  // FirestoreService의 인스턴스를 저장할 정적 변수
  static final FirestoreService _instance = FirestoreService._internal();

  // 내부 생성자
  FirestoreService._internal();

  // 공용 팩토리 생성자
  factory FirestoreService() {
    return _instance;
  }

  // Firestore 인스턴스
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final LocalQuiz _localQuiz = LocalQuiz();

  int fixedLimit = 30;

  // Firestore에서 문서를 제한된 개수만큼 가져오는 메서드
  Future<List<Quiz>> getLimitedDocuments(
      String collectionPath, int limit) async {

    final snapshot = await db
        .collection(collectionPath)
        .limit(limit)
        .get();

    List<Quiz> quizzes = convertSnapshotsToQuizList(snapshot.docs, collectionPath);
    return quizzes;
  }


  List<Quiz> convertSnapshotsToQuizList(List<DocumentSnapshot> snapshots, String collectionPath) {
    List<Quiz> quizList = [];
    for (var snapshot in snapshots) {
      Quiz quiz = Quiz(
        id: snapshot.id,
        generatedTime: DateTime.now(), // 예시로 현재 시간을 사용
        category: collectionPath, // category가 null일 경우 collectionPath로 설정
        first_category: (collectionPath == 'toeic') ? 'Part 5' : null,
        second_category: null,
        third_category: null,
        title: null,
        question: snapshot.get('question') ?? '', // question이 null일 경우 빈 문자열로 설정
        choices: List<String>.from(snapshot.get('choices') ?? []), // choices가 null일 경우 빈 리스트로 설정
        answer: snapshot.get('answer') ?? '', // answer가 null일 경우 빈 문자열로 설정
        like_count: null,
        dislike_count: null,
        progress_Time: null,
        status: null,
        explanation: null
      );
      quizList.add(quiz);
    }
    return quizList;
  }

}
