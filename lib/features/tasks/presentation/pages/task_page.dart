import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Taskboard')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          // 1. Show Spinner while loading
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. Show the List when data arrives
          else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description ?? 'No description'),
                  trailing: Chip(label: Text(task.priority)),
                );
              },
            );
          }
          // 3. Show Error if something went wrong
          else if (state is TaskError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No tasks found.'));
        },
      ),
    );
  }
}
