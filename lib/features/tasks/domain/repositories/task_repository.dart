import 'package:taskboard_app/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {

  Future<List<Task>> getTasks();

  Future<void> addTask(String title, String? description, String priority);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String id);

}