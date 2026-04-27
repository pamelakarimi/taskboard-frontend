import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
  });

  // Equatable uses this to check if two tasks are the same without 
  // rebuilding the UI unnecessarily.
  @override
  List<Object?> get props => [id, title, description, status, priority];
}