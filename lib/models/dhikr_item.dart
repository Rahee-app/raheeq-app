class DhikrItem {
  final String id;
  final String text;
  final String countText;
  final int targetCount;
  int currentCount;
  bool isCompleted;

  DhikrItem({
    required this.id,
    required this.text,
    required this.countText,
    required this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  void increment() {
    if (currentCount < targetCount) {
      currentCount++;
      if (currentCount >= targetCount) {
        isCompleted = true;
      }
    }
  }

  void toggleComplete() {
    if (isCompleted) {
      isCompleted = false;
      currentCount = 0;
    } else {
      isCompleted = true;
      currentCount = targetCount;
    }
  }

  void reset() {
    currentCount = 0;
    isCompleted = false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'countText': countText,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'isCompleted': isCompleted,
    };
  }

  factory DhikrItem.fromJson(Map<String, dynamic> json) {
    return DhikrItem(
      id: json['id'] as String,
      text: json['text'] as String,
      countText: (json['countText'] as String?) ?? 'مرة واحدة',
      targetCount: (json['targetCount'] as int?) ?? 1,
      currentCount: (json['currentCount'] as int?) ?? 0,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
    );
  }

  DhikrItem copyWith({
    String? id,
    String? text,
    String? countText,
    int? targetCount,
    int? currentCount,
    bool? isCompleted,
  }) {
    return DhikrItem(
      id: id ?? this.id,
      text: text ?? this.text,
      countText: countText ?? this.countText,
      targetCount: targetCount ?? this.targetCount,
      currentCount: currentCount ?? this.currentCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
