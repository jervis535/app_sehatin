class MedicalHistory {
  final int id;
  final int userId;
  final String medications;
  final String medicalConditions;
  final String notes;

  MedicalHistory({
    required this.id,
    required this.userId,
    required this.medications,
    required this.medicalConditions,
    required this.notes,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      id: json['id'],
      userId: json['user_id'],
      medications: json['medications'],
      medicalConditions: json['medical_conditions'],
      notes: json['notes'],
    );
  }
}
