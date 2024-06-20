

import 'dart:math';
import 'dart:ui';

final examples = TestExamples(
  id: '0',
  // 예시 데이터를 생성할 때 필요한 기본 값
  generatedTime: DateTime.now(),
  category: 'Default Category',
  first_category: 'Default First Category',
  second_category2: 'Default Second Category',
  third_category3: 'Default Third Category',
  title: 'Default Example Quiz',
  question: 'Default Question?',
  choices: ['Default Option 1', 'Default Option 2'],
  // 선택지 예시
  answer: 'Default Option 1',
  // 정답 예시
  like_count: 0,
  dislike_count: 0,
  progress_Time: 0.0,
);

final data = examples.createExampleDataList();

class TestExamples {

  String id;
  DateTime generatedTime;
  String category;
  String first_category;
  String second_category2;
  String third_category3;
  String title;
  String question;
  List<String> choices = [];
  String answer;
  int? like_count;
  int? dislike_count;
  double progress_Time;
  Color? color;

  TestExamples({
    required this.id,
    required this.generatedTime,
    required this.category,
    required this.first_category,
    required this.second_category2,
    required this.third_category3,
    required this.title,
    required this.question,
    required this.choices,
    required this.answer,
    this.like_count,
    this.dislike_count,
    required this.progress_Time,
    this.color
  });

  // Convert QuizData instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'generatedTime': generatedTime,
      'category': category,
      'first_category': first_category,
      'second_category2': second_category2,
      'third_category3': third_category3,
      'title': title,
      'question': question,
      'choices': choices,
      'answer': answer,
      'like_count': like_count,
      'dislike_count': dislike_count,
      'progress_Time': progress_Time,
    };
  }

  // // Convert Firestore DocumentSnapshot to QuizData instance
  // factory QuizData.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return QuizData(
  //     id: data['id'],
  //     generatedTime: (data['generatedTime'] as Timestamp).toDate(),
  //     category: data['category'],
  //     first_category: data['first_category'],
  //     second_category2: data['second_category2'],
  //     third_category3: data['third_category3'],
  //     title: data['title'],
  //     question: data['question'],
  //     choices: List<String>.from(data['choices']),
  //     answer: data['answer'],
  //     like_count: data['like_count'],
  //     dislike_count: data['dislike_count'],
  //     progress_Time: data['progress_Time'],
  //   );
  // }

  // 예시 데이터 생성
  // TestExamples quizData = TestExamples(
  //   id: '1',
  //   generatedTime: DateTime.now(),
  //   category: 'Category',
  //   first_category: 'First Category',
  //   second_category2: 'Second Category',
  //   third_category3: 'Third Category',
  //   title: 'Example Quiz',
  //   question: 'What is the capital of France?',
  //   choices: ['Paris', 'London', 'Berlin', 'Seoul'],
  //   answer: 'Paris',
  //   like_count: 10,
  //   dislike_count: 2,
  //   progress_Time: 0.75,
  // );

  List<TestExamples> createExampleDataList() {
    List<TestExamples> examplesList = [];

    for (int i = 1; i <= 10; i++) {
      TestExamples example = TestExamples(
        id: '$i',
        generatedTime: DateTime.now().subtract(Duration(days: i)), // 각 데이터마다 시간을 이전 날짜로 설정
        category: 'Category $i',
        first_category: 'First Category $i',
        second_category2: 'Second Category $i',
        third_category3: 'Third Category $i',
        title: 'Example Quiz $i',
        question: 'Question $i?',
        choices: ['Option 1', 'Option 2', 'Option 3', 'Option 4'], // 선택지 예시
        answer: 'Option 1', // 정답 예시
        like_count: i * 5, // 좋아요 개수 예시
        dislike_count: i * 2, // 싫어요 개수 예시
        progress_Time: i * 0.1, // 진행 시간 예시
        color: colorGenerator()
      );
      examplesList.add(example);
    }

    return examplesList;
  }

  Color colorGenerator() {
    // 주어진 색상 리스트
    List<Color> colors = [
      Color(0xFFF6D98B), // Apricot
      Color(0xDDAFBFFD), // Puppleberry (alpha value in hex)
      Color(0xFFF2E500), // Mango
      Color(0xFF005242), // Forest (alpha value in hex)
      Color(0xFF3ECDFE),    // Cerulean (alpha value in hex)
      Color(0xFFFF8080),    // Strawberry (alpha value in hex)
      Color(0xFFFE7A36),    // Orange
      Color(0xFFBF313F),    // Brick
      Color(0xFFA0E9FF),    // Winter
      Color(0xFFA7D397),    // Olive
    ];

    // 무작위 인덱스 생성
    Random random = Random();
    int index = random.nextInt(colors.length);

    // 무작위로 선택된 색상 반환
    return colors[index];
  }
}