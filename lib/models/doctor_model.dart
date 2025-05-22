class DoctorModel {
  final int userId;
  final String specialization;
  final int poiId;

  DoctorModel({required this.userId, required this.specialization, required this.poiId});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      userId: json['user_id'],
      specialization: json['specialization'],
      poiId: json['poi_id']
    );
  }

  @override
  String toString() {
    return 'DoctorModel(userId: $userId, specialization: $specialization, poiId: $poiId)';
  }
}

