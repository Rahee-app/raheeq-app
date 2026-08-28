enum TaskType {
  prayer,
  quran,
  morningAdhkar,
  tasbeeh,
}

class TaskItem {
  final String id;
  final String title;
  final String subtitle;
  final TaskType type;
  bool isCompleted;
  final String? actionRoute;

  TaskItem({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.type,
    this.isCompleted = false,
    this.actionRoute,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    TaskType? type,
    bool? isCompleted,
    String? actionRoute,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.name,
      'isCompleted': isCompleted,
      'actionRoute': actionRoute,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: (json['subtitle'] as String?) ?? '',
      type: TaskType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TaskType.prayer,
      ),
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      actionRoute: json['actionRoute'] as String?,
    );
  }
}
