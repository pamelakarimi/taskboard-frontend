import 'package:taskboard_app/core/constants/api_constants.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Task>> getTasks() async {
    return await remoteDataSource.getTasks(ApiConstants.tempToken);
  }

  @override
  Future<void> addTask(String title, String? description, String priority) async {
    final taskMap = {'title': title, 'description': description, 'priority': priority, 'status': 'To Do'};

    return await remoteDataSource.addTask(ApiConstants.tempToken, taskMap);
  }

  @override
  Future<void> updateTask(Task task) async {
    // We convert the task entity back to a map for the API
    final updateData = {
      'title': task.title,
      'description': task.description,
      'priority': task.priority,
      'status': task.status,
    };
    return await remoteDataSource.updateTask(ApiConstants.tempToken, task.id, updateData);
  }

  @override
  Future<void> deleteTask(String id) async {
    return await remoteDataSource.deleteTask(ApiConstants.tempToken, id);
  }
}
