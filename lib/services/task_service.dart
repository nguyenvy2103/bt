import '../models/task.dart';

class TaskService {
  final List<Task> _tasks = [];

  Future<List<Task>> fetchTasks() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _tasks;
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    _tasks[index] = task;
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
  }
}
