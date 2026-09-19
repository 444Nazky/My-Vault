import 'package:hive/hive.dart';
import 'vehicle_model.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class TripModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String noTrip;

  @HiveField(2)
  String userId;

  @HiveField(3)
  String regionId;

  @HiveField(4)
  String? rute;

  @HiveField(5)
  String statusMuatan; // 'ada_muatan' atau 'kosong'

  @HiveField(6)
  String? keterangan;

  @HiveField(7)
  String? fotoKondisiPath;

  @HiveField(8)
  double startLat;

  @HiveField(9)
  double startLng;

  @HiveField(10)
  double? endLat;

  @HiveField(11)
  double? endLng;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime? completedAt;

  @HiveField(14)
  List<VehicleModel> vehicles;

  @HiveField(15)
  bool isSynced;

  @HiveField(16)
  int syncRetryCount;

  @HiveField(17)
  String status; // 'active', 'completed', 'failed'

  TripModel({
    required this.id,
    required this.noTrip,
    required this.userId,
    required this.regionId,
    this.rute,
    required this.statusMuatan,
    this.keterangan,
    this.fotoKondisiPath,
    required this.startLat,
    required this.startLng,
    this.endLat,
    this.endLng,
    DateTime? createdAt,
    this.completedAt,
    List<VehicleModel>? vehicles,
    this.isSynced = false,
    this.syncRetryCount = 0,
    this.status = 'active',
  })  : createdAt = createdAt ?? DateTime.now(),
        vehicles = vehicles ?? [];

  // Generate nomor trip: TRP-DDMMYY-SEQ
  static String generateNoTrip(int sequence) {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString().substring(2);
    final seq = sequence.toString().padLeft(3, '0');
    return 'TRP-$day$month$year-$seq';
  }

  // Total tarif dari semua kendaraan
  int get totalTarif {
    return vehicles.fold(0, (sum, v) => sum + v.tarif);
  }

  // Jumlah kendaraan
  int get vehicleCount => vehicles.length;

  // Apakah trip kosong
  bool get isKosong => statusMuatan == 'kosong';

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      noTrip: json['no_trip'] as String,
      userId: json['user_id'] as String,
      regionId: json['region_id'] as String,
      rute: json['rute'] as String?,
      statusMuatan: json['status_muatan'] as String,
      keterangan: json['keterangan'] as String?,
      fotoKondisiPath: json['foto_kondisi_path'] as String?,
      startLat: (json['start_lat'] as num).toDouble(),
      startLng: (json['start_lng'] as num).toDouble(),
      endLat: json['end_lat'] != null ? (json['end_lat'] as num).toDouble() : null,
      endLng: json['end_lng'] != null ? (json['end_lng'] as num).toDouble() : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      vehicles: (json['vehicles'] as List<dynamic>?)
              ?.map((v) => VehicleModel.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
      isSynced: json['is_synced'] as bool? ?? false,
      syncRetryCount: json['sync_retry_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'no_trip': noTrip,
      'user_id': userId,
      'region_id': regionId,
      'rute': rute,
      'status_muatan': statusMuatan,
      'keterangan': keterangan,
      'foto_kondisi_path': fotoKondisiPath,
      'start_lat': startLat,
      'start_lng': startLng,
      'end_lat': endLat,
      'end_lng': endLng,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'vehicles': vehicles.map((v) => v.toJson()).toList(),
      'is_synced': isSynced,
      'sync_retry_count': syncRetryCount,
      'status': status,
    };
  }

  TripModel copyWith({
    String? id,
    String? noTrip,
    String? userId,
    String? regionId,
    String? rute,
    String? statusMuatan,
    String? keterangan,
    String? fotoKondisiPath,
    double? startLat,
    double? startLng,
    double? endLat,
    double? endLng,
    DateTime? completedAt,
    List<VehicleModel>? vehicles,
    bool? isSynced,
    int? syncRetryCount,
    String? status,
  }) {
    return TripModel(
      id: id ?? this.id,
      noTrip: noTrip ?? this.noTrip,
      userId: userId ?? this.userId,
      regionId: regionId ?? this.regionId,
      rute: rute ?? this.rute,
      statusMuatan: statusMuatan ?? this.statusMuatan,
      keterangan: keterangan ?? this.keterangan,
      fotoKondisiPath: fotoKondisiPath ?? this.fotoKondisiPath,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      endLat: endLat ?? this.endLat,
      endLng: endLng ?? this.endLng,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      vehicles: vehicles ?? this.vehicles,
      isSynced: isSynced ?? this.isSynced,
      syncRetryCount: syncRetryCount ?? this.syncRetryCount,
      status: status ?? this.status,
    );
  }
}