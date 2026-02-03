import 'package:cloud_firestore/cloud_firestore.dart';

/// ================= ATTACHMENT MODEL =================
class TaskAttachment {
  final String name;
  final String url;

  TaskAttachment({
    required this.name,
    required this.url,
  });

  factory TaskAttachment.fromMap(Map<String, dynamic> map) {
    return TaskAttachment(
      name: map['name'] as String? ?? '',
      url: map['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }
}

/// ================= TASK MODEL =================
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;
  final List<TaskAttachment> attachments;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.attachments = const [],
  });

  bool get isCompleted => status == 'Completed';

  /// ================= FROM FIRESTORE =================
  factory Task.fromJson(Map<String, dynamic> json, String id) {
    /// ⚠️ handle dueDate an toàn
    DateTime parsedDueDate;

    final dueDateRaw = json['dueDate'];
    if (dueDateRaw is String) {
      parsedDueDate = DateTime.tryParse(dueDateRaw) ?? DateTime.now();
    } else if (dueDateRaw is Timestamp) {
      parsedDueDate = dueDateRaw.toDate();
    } else {
      parsedDueDate = DateTime.now();
    }

    return Task(
      id: id,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dueDate: parsedDueDate,
      status: json['status'] as String? ?? 'Pending',
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map(
            (e) => TaskAttachment.fromMap(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList(),
    );
  }

  /// ================= TO FIRESTORE =================
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status,
      'attachments': attachments.map((e) => e.toMap()).toList(),
    };
  }
}
