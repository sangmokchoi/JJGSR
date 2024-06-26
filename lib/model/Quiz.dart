import 'package:hive/hive.dart';

part 'Quiz.g.dart';

@HiveType(typeId: 0)
class Quiz extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime generatedTime;

  @HiveField(2)
  late String category;

  @HiveField(3)
  late String? first_category;

  @HiveField(4)
  late String? second_category;

  @HiveField(5)
  late String? third_category;

  @HiveField(6)
  late String? title;

  @HiveField(7)
  late String question;

  @HiveField(8)
  late List<String> choices;

  @HiveField(9)
  late String answer;

  @HiveField(10)
  late int? like_count;

  @HiveField(11)
  late int? dislike_count;

  @HiveField(12)
  late double? progress_Time;

  @HiveField(13)
  late int? status; // null 아직 풀지 않음, -1 틀림, 0 스킵, 1 맞힘

  Quiz({
    required this.id,
    required this.generatedTime,
    required this.category,
    this.first_category,
    this.second_category,
    this.third_category,
    this.title,
    required this.question,
    required this.choices,
    required this.answer,
    this.like_count,
    this.dislike_count,
    this.progress_Time,
    this.status,
  });

  // toJson 메서드: 객체를 Map으로 직렬화합니다.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'generatedTime': generatedTime.toIso8601String(),
      'category': category,
      'question': question,
      'choices': choices,
      'answer': answer,
    };

    if (first_category != null) {
      json['first_category'] = first_category;
    }
    if (second_category != null) {
      json['second_category'] = second_category;
    }
    if (third_category != null) {
      json['third_category'] = third_category;
    }
    if (title != null) {
      json['title'] = title;
    }
    if (like_count != null) {
      json['like_count'] = like_count;
    }
    if (dislike_count != null) {
      json['dislike_count'] = dislike_count;
    }
    if (progress_Time != null) {
      json['progress_Time'] = progress_Time;
    }
    if (status != null) {
      json['status'] = status;
    }

    return json;
  }

  // fromJson 팩토리 메서드: Map을 객체로 역직렬화합니다.
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      generatedTime: DateTime.parse(json['generatedTime']),
      category: json['category'],
      first_category: json['first_category'],
      second_category: json['second_category'],
      third_category: json['third_category'],
      title: json['title'],
      question: json['question'],
      choices: List<String>.from(json['choices']),
      answer: json['answer'],
      like_count: json['like_count'],
      dislike_count: json['dislike_count'],
      progress_Time: json['progress_Time'],
      status: json['status'],
    );
  }
}
