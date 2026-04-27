import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String token);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final http.Client client;
  final String baseUrl = "http://192.168.100.4:5000/api/tasks"; 

  TaskRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TaskModel>> getTasks(String token) async {
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
}