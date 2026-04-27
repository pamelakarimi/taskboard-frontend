import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:taskboard_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:taskboard_app/features/tasks/data/datasources/task_repository_impl.dart';
import 'package:taskboard_app/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:taskboard_app/features/tasks/presentation/pages/task_page.dart';

void main() {
  final httpClient = http.Client();
  final remoteDataSource = TaskRemoteDataSourceImpl(client: httpClient);
  final taskRepository = TaskRepositoryImpl(remoteDataSource: remoteDataSource);

  runApp(MyApp(taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl taskRepository;
  const MyApp({super.key, required this.taskRepository});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskBoard App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => TaskCubit(repository: taskRepository)..fetchTasks(),
        child: const TaskPage(),
      ),
    );
  }
}



