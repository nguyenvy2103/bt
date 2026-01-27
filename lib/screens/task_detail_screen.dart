import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:url_launcher/url_launcher.dart';

import '../models/task.dart' as model;

class TaskDetailScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  model.Task? task;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  /// ================= LOAD TASK =================
  Future<void> _loadTask() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .get();

      if (!doc.exists || doc.data() == null) {
        throw Exception('Task not found');
      }

      task = model.Task.fromJson(doc.data()!, doc.id);
    } catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  /// ================= ADD ATTACHMENT =================
  Future<void> _addAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;

      final ref = storage.FirebaseStorage.instance
          .ref('attachments/${widget.taskId}/$fileName');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskId)
          .update({
        'attachments': FieldValue.arrayUnion([
          {'name': fileName, 'url': url}
        ])
      });

      await _loadTask();
    } catch (e) {
      debugPrint('Add attachment error: $e');
    }
  }

  /// ================= OPEN FILE =================
  Future<void> _openFile(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail')),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('tasks')
                  .doc(task!.id)
                  .delete();

              if (!mounted) return;
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              task!.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),

            /// DESCRIPTION
            Text(task!.description),
            const SizedBox(height: 16),

            /// INFO CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(
                    icon: Icons.event,
                    label: _formatDate(task!.dueDate),
                  ),
                  _InfoItem(
                    icon: Icons.sync,
                    label: task!.status,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// ATTACHMENTS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Attachments',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addAttachment,
                ),
              ],
            ),

            if (task!.attachments.isEmpty)
              const Text('No attachments'),

            ...task!.attachments.map(
                  (file) => ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(file.name),
                onTap: () => _openFile(file.url),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year}';
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
