import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => _TaskAddScreenState();
}

class _TaskAddScreenState extends State<TaskAddScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime _dueDate = DateTime.now();
  String _status = 'Pending';

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TITLE
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            const SizedBox(height: 12),

            /// DESCRIPTION
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            const SizedBox(height: 12),

            /// STATUS
            DropdownButtonFormField<String>(
              value: _status,
              items: ['Pending', 'In Progress', 'Completed']
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() => _status = value!);
              },
              decoration: const InputDecoration(labelText: 'Status'),
            ),

            const SizedBox(height: 12),

            /// DUE DATE
            Row(
              children: [
                Text(
                  'Due: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() => _dueDate = picked);
                    }
                  },
                )
              ],
            ),

            const Spacer(),

            /// SAVE
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_titleController.text.isEmpty) return;

                  provider.addTask(
                    Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      description: _descController.text,
                      dueDate: _dueDate,
                      status: _status,
                    ),
                  );

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
