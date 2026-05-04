import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taskboard_app/core/constants/api_constants.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String token);
  Future<void> addTask(String token, Map<String, dynamic> taskData);
  Future<void> updateTask(String token, String id, Map<String, dynamic> updateData);
  Future<void> deleteTask(String token, String id);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;

  TaskRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TaskModel>> getTasks(String token) async {
    final response = await client.get(
      Uri.parse("${ApiConstants.baseUrl}/tasks"),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List decodeData = json.decode(response.body);
      return decodeData.map((task) => TaskModel.fromJson(task)).toList();
    } else {
      print("Backend Error: ${response.statusCode}");
      print("Response Body: ${response.body}");
      throw Exception('Failed to load tasks: ${response.statusCode}');
    }
  }

  @override
  Future<void> addTask(String token, Map<String, dynamic> taskData) async {
    final response = await client.post(
      Uri.parse("${ApiConstants.baseUrl}/tasks"),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: json.encode(taskData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  @override
  Future<void> updateTask(String token, String id, Map<String, dynamic> updateData) async {
    final response = await client.patch(
      Uri.parse("${ApiConstants.baseUrl}/tasks/$id"),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: json.encode(updateData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  @override
  Future<void> deleteTask(String token, String id) async {
    final response = await client.delete(
      Uri.parse("${ApiConstants.baseUrl}/tasks/$id"),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}
