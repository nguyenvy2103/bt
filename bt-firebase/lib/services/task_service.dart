import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _storageKey = 'tasks_data';

  Future<List<Task>> fetchTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_storageKey);
    if (tasksJson == null) return [];

    final List<dynamic> decodedList = jsonDecode(tasksJson);
    return decodedList.map((item) {
      // Đảm bảo ID được truyền vào từ map dữ liệu
      return Task.fromJson(item, item['id'] ?? '');
    }).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(
      tasks.map((task) {
        final map = task.toJson();
        map['id'] = task.id; // Lưu ID để khi load lại có thể dùng
        map['dueDate'] = task.dueDate.toIso8601String(); // Lưu dạng String thay vì Timestamp
        return map;
      }).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> addTask(Task task) async {
    final tasks = await fetchTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  // Bổ sung phương thức Update
  Future<void> updateTask(Task task) async {
    final tasks = await fetchTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  // Bổ sung phương thức Delete
  Future<void> deleteTask(String id) async {
    final tasks = await fetchTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }
}