import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();
  List<Task> _tasks = []; // Chuyển thành private để kiểm soát dữ liệu tốt hơn

  List<Task> get tasks => _tasks;

  /// Tự động load dữ liệu ngay khi Provider được khởi tạo
  TaskProvider() {
    loadTasks();
  }

  /// Tải dữ liệu từ Local Storage thông qua Service
  Future<void> loadTasks() async {
    _tasks = await _service.fetchTasks();
    notifyListeners();
  }

  /// Thêm mới: Cập nhật UI ngay lập tức và lưu vào máy
  Future<void> addTask(Task task) async {
    // 1. Lưu vào service (Local Storage)
    await _service.addTask(task);

    // 2. Cập nhật danh sách hiển thị
    _tasks.add(task);

    // 3. Thông báo cho UI cập nhật ngay
    notifyListeners();
  }

  /// Cập nhật: Tìm task theo ID và thay thế
  Future<void> updateTask(Task task) async {
    await _service.updateTask(task);

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  /// Xóa: Xóa khỏi bộ nhớ cục bộ và danh sách hiển thị
  Future<void> deleteTask(String id) async {
    await _service.deleteTask(id);

    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  /// Lấy chi tiết task
  Task getTaskById(String id) {
    return _tasks.firstWhere((t) => t.id == id);
  }
}