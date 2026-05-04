import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskboard_app/features/tasks/domain/entities/task.dart';
import 'task_state.dart';
import '../../domain/repositories/task_repository.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository;

  TaskCubit({required this.repository}) : super(TaskInitial());

  Future<void> fetchTasks() async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(String title, String? description, String priority) async {
    try {
      await repository.addTask(title, description, priority);
      await fetchTasks();
    } catch (e) {
      emit(TaskError("Could not add task: ${e.toString()}"));
    }
  }

  Future<void> updateTaskStatus(Task task, String newStatus) async {
    try {
      // Create a copy of the task with the dropped-to status
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        priority: task.priority,
        status: newStatus,
      );

      // Persist to MongoDB via Repository
      await repository.updateTask(updatedTask);
      
      // Refresh list to show task in its new column
      await fetchTasks(); 
    } catch (e) {
      emit(TaskError("Failed to move task: ${e.toString()}"));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await repository.deleteTask(id);
      await fetchTasks();
    } catch (e) {
      emit(TaskError("Could not delete task: ${e.toString()}"));
    }
  }
}
