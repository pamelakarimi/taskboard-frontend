
import 'package:taskboard_app/features/tasks/domain/entities/task.dart';

class TaskModel extends Task{
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.status,
    required super.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '', 
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'To Do',
      priority: json['priority'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
     'title': title,
      'description': description,
      'status': status,
      'priority': priority,
    };
  }
}