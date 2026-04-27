import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Task>> getTasks() async {
    // For now, we are passing a hardcoded token to test. 
    // Later, we will get this from your Secure Storage!
    const String temporaryToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWU4YTA3OWIxMzI1NjIyZTNkNmI0NmUiLCJpYXQiOjE3NzcyNjc1MzIsImV4cCI6MTc3NzI3MTEzMn0.9VtyEpc8yhgo0z9_W41d82qI4qfgBw6JH033YD6F1rg";
    
    return await remoteDataSource.getTasks(temporaryToken);
  }

  // We will implement these as we build the UI forms
  @override
  Future<void> addTask(Task task) async => throw UnimplementedError();

  @override
  Future<void> updateTask(Task task) async => throw UnimplementedError();

  @override
  Future<void> deleteTask(String id) async => throw UnimplementedError();
}