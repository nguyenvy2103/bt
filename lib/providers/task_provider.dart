import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();
  List<Task> tasks = [];

  Future<void> loadTasks() async {
    tasks = await _service.fetchTasks();
    notifyListeners();
  }

  void addTask(Task task) {
    _service.addTask(task);
    tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    _service.updateTask(task);
    final index = tasks.indexWhere((t) => t.id == task.id);
    tasks[index] = task;
    notifyListeners();
  }

  void deleteTask(String id) {
    _service.deleteTask(id);
    tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Task getTaskById(String id) {
    return tasks.firstWhere((t) => t.id == id);
  }
}
