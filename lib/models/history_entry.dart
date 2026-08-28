class HistoryEntry {
  final String dateKey; // Format: YYYY-MM-DD
  final DateTime date;
  final int completedTasksCount;
  final int totalTasksCount;
  final bool isFullyCompleted;

  HistoryEntry({
    required this.dateKey,
    required this.date,
    required this.completedTasksCount,
    this.totalTasksCount = 8,
    required this.isFullyCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateKey': dateKey,
      'date': date.toIso8601String(),
      'completedTasksCount': completedTasksCount,
      'totalTasksCount': totalTasksCount,
      'isFullyCompleted': isFullyCompleted,
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      dateKey: json['dateKey'] as String,
      date: DateTime.parse(json['date'] as String),
      completedTasksCount: (json['completedTasksCount'] as int?) ?? 0,
      totalTasksCount: (json['totalTasksCount'] as int?) ?? 8,
      isFullyCompleted: (json['isFullyCompleted'] as bool?) ?? false,
    );
  }
}
