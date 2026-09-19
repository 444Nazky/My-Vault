import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String regionId;

  @HiveField(3)
  String deviceId;

  @HiveField(4)
  String? role;

  @HiveField(5)
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.regionId,
    required this.deviceId,
    this.role,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      regionId: json['region_id'] as String,
      deviceId: json['device_id'] as String,
      role: json['role'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'region_id': regionId,
      'device_id': deviceId,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? nama,
    String? regionId,
    String? deviceId,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      regionId: regionId ?? this.regionId,
      deviceId: deviceId ?? this.deviceId,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}