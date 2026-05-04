import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taskboard_app/features/tasks/domain/entities/task.dart';
import '../cubit/task_cubit.dart';
import '../cubit/task_state.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Taskboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final statuses = ['To Do', 'In Progress', 'Done'];

            return PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              itemCount: statuses.length,
              itemBuilder: (context, index) {
                final currentStatus = statuses[index];
                final columnTasks = state.tasks.where((task) => task.status == currentStatus).toList();

                return DragTarget<Task>(
                  // Only accept if the task is coming from a DIFFERENT column
                  onWillAccept: (data) => data?.status != currentStatus,
                  onAccept: (task) {
                    context.read<TaskCubit>().updateTaskStatus(task, currentStatus);
                  },
                  builder: (context, candidateData, rejectedData) {
                    // isHovering is true when a card is held over this specific column
                    bool isHovering = candidateData.isNotEmpty;

                    return _buildKanbanColumn(context, currentStatus, columnTasks, isHovering: isHovering);
                  },
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)));
        },
      ),
    );
  }

  Widget _buildKanbanColumn(BuildContext context, String status, List<Task> tasks, {bool isHovering = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        // The "Glow" effect: change color and add a border when hovering
        color: isHovering ? Colors.pink[50] : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isHovering ? const Color(0xFFE91E63) : Colors.transparent, width: 2),
        boxShadow: [
          if (isHovering) BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.2), blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)),
                  child: Text('${tasks.length}', style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LongPressDraggable<Task>(
                    data: task,
                    // What the user sees under their finger while dragging
                    feedback: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: _buildTaskCard(task, isDragging: true),
                      ),
                    ),
                    // What remains in the list while the card is being dragged
                    childWhenDragging: Opacity(opacity: 0.2, child: _buildTaskCard(task)),
                    child: _buildTaskCard(task),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task, {bool isDragging = false}) {
    return Card(
      elevation: isDragging ? 12 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border(left: BorderSide(color: _getPriorityColor(task.priority), width: 5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (task.description != null && task.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  // Reuse your existing skeleton loader, but wrapped for the new layout
  Widget _buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE91E63))),
              ),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFE91E63))),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  context.read<TaskCubit>().addTask(titleController.text, descController.text, 'Medium');
                  Navigator.pop(sheetContext);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63)),
              child: const Text('Save Task', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
