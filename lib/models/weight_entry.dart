class WeightEntry {
  final int? id;
  final String userId;
  final double weight;
  final DateTime date;

  WeightEntry({
    this.id,
    required this.userId,
    required this.weight,
    required this.date,
  });

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      userId: map['user_id'],
      weight: map['weight'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'date': date.toIso8601String(),
    };
  }
}
