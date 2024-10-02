// To parse this JSON data, do
//
//     final allTest = allTestFromJson(jsonString);

import 'dart:convert';

List<GetTask> allTestFromJson(String str) => List<GetTask>.from(json.decode(str).map((x) => GetTask.fromJson(x)));

String allTestToJson(List<GetTask> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetTask {
  int taskId;
  String? title;
  String? description;
  DateTime? dateOfCompletion;
  String? timeOfCompletion;
  String? taskCategory;
  String? priority;
  String? completed;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? userId;

  GetTask({
    required this.taskId,
    this.title,
    this.description,
    this.dateOfCompletion,
    this.timeOfCompletion,
    this.taskCategory,
    this.priority,
    this.completed,
    this.createdAt,
    this.updatedAt,
    this.userId,
  });

  GetTask copyWith({
    int? taskId,
    String? title,
    String? description,
    DateTime? dateOfCompletion,
    String? timeOfCompletion,
    String? taskCategory,
    String? priority,
    String? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) =>
      GetTask(
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        description: description ?? this.description,
        dateOfCompletion: dateOfCompletion ?? this.dateOfCompletion,
        timeOfCompletion: timeOfCompletion ?? this.timeOfCompletion,
        taskCategory: taskCategory ?? this.taskCategory,
        priority: priority ?? this.priority,
        completed: completed ?? this.completed,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userId: userId ?? this.userId,
      );

  factory GetTask.fromJson(Map<String, dynamic> json) => GetTask(
    taskId: int.tryParse(json["task_id"].toString()) ?? 0,
    title: json["title"],
    description: json["description"],
    dateOfCompletion: json["date_of_completion"] == null ? null : DateTime.parse(json["date_of_completion"]),
    timeOfCompletion: json["time_of_completion"],
    taskCategory: json["task_category"],
    priority: json["priority"],
    completed: json["completed"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "task_id": taskId,
    "title": title,
    "description": description,
    "date_of_completion": "${dateOfCompletion!.year.toString().padLeft(4, '0')}-${dateOfCompletion!.month.toString().padLeft(2, '0')}-${dateOfCompletion!.day.toString().padLeft(2, '0')}",
    "time_of_completion": timeOfCompletion,
    "task_category": taskCategory,
    "priority": priority,
    "completed": completed,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_id": userId,
  };
}
