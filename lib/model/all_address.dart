// @dart=2.9
// To parse this JSON data, do
//
//     final allQuestion = allQuestionFromJson(jsonString);

import 'dart:convert';

List<AllQuestion> allQuestionFromJson(String str) => List<AllQuestion>.from(json.decode(str).map((x) => AllQuestion.fromJson(x)));

String allQuestionToJson(List<AllQuestion> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllQuestion {
  AllQuestion({
    this.questionId,
    this.question,
    this.isActive,
    this.answerModels,
    this.tag,
  });

  int tag;
  int questionId;
  String question;
  bool isActive;
  List<AnswerModel> answerModels;

  factory AllQuestion.fromJson(Map<String, dynamic> json) => AllQuestion(
        questionId: json["questionId"],
        question: json["question"],
        isActive: json["isActive"],
        answerModels: List<AnswerModel>.from(json["answerModels"].map((x) => AnswerModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "question": question,
        "isActive": isActive,
        "answerModels": List<dynamic>.from(answerModels.map((x) => x.toJson())),
      };
}

class AnswerModel {
  AnswerModel({
    this.answerId,
    this.questionId,
    this.answer,
    this.isSelected,
    this.tag,
  });

  int tag;
  int answerId;
  int questionId;
  String answer;
  bool isSelected;

  factory AnswerModel.fromJson(Map<String, dynamic> json) => AnswerModel(
        answerId: json["answerId"],
        questionId: json["questionId"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "answerId": answerId,
        "questionId": questionId,
        "answer": answer,
      };
}

enum Answer { YES, NO }

final answerValues = EnumValues({"No": Answer.NO.toString(), "Yes": Answer.YES.toString()});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
