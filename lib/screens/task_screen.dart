import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';
import 'task_add_screen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  Color getTaskColor(String status) {
    switch (status) {
      case 'In Progress':
        return const Color(0xFFE6A6A6);
      case 'Pending':
        return const Color(0xFFE9E7A6);
      case 'Completed':
        return const Color(0xFFBFE6E6);
      default:
        return Colors.grey.shade200;
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final List<Task> tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        centerTitle: true,
      ),

      /// BODY
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getTaskColor(task.status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        TaskDetailScreen(taskId: task.id),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    task.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color:
                    task.isCompleted ? Colors.green : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(task.description),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${task.status}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  formatDate(task.dueDate),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      /// ADD BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TaskAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
