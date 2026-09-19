import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 2)
class VehicleModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String tripId;

  @HiveField(2)
  int kendaraanKe; // Urutan kendaraan dalam trip

  @HiveField(3)
  String noPolisi; // Plat nomor kendaraan

  @HiveField(4)
  String golongan; // 'internal' atau 'eksternal'

  @HiveField(5)
  String jenisKendaraan; // 'truk', 'mobil', 'motor'

  @HiveField(6)
  String muatan; // 'dengan_muatan' atau 'tanpa_muatan'

  @HiveField(7)
  String? fotoSelfiePath; // Lokasi foto selfie di device

  @HiveField(8)
  String? fotoSelfieUrl; // URL foto di server

  @HiveField(9)
  int tarif;

  @HiveField(10)
  double lat;

  @HiveField(11)
  double lng;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  bool isSynced;

  @HiveField(14)
  int syncRetryCount;

  VehicleModel({
    required this.id,
    required this.tripId,
    required this.kendaraanKe,
    required this.noPolisi,
    required this.golongan,
    required this.jenisKendaraan,
    required this.muatan,
    this.fotoSelfiePath,
    this.fotoSelfieUrl,
    this.tarif = 0,
    required this.lat,
    required this.lng,
    DateTime? createdAt,
    this.isSynced = false,
    this.syncRetryCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  // Label golongan
  String get golonganLabel {
    switch (golongan) {
      case 'internal':
        return 'Internal';
      case 'eksternal':
        return 'Eksternal';
      default:
        return golongan;
    }
  }

  // Label jenis kendaraan
  String get jenisLabel {
    switch (jenisKendaraan) {
      case 'truk':
        return 'Truk';
      case 'mobil':
        return 'Mobil';
      case 'motor':
        return 'Motor';
      default:
        return jenisKendaraan;
    }
  }

  // Label muatan
  String get muatanLabel {
    switch (muatan) {
      case 'dengan_muatan':
        return 'Dengan Muatan';
      case 'tanpa_muatan':
        return 'Tanpa Muatan';
      default:
        return muatan;
    }
  }

  // Format tarif
  String get tarifFormatted {
    return 'Rp ${tarif.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      kendaraanKe: json['kendaraan_ke'] as int,
      noPolisi: json['no_polisi'] as String,
      golongan: json['golongan'] as String,
      jenisKendaraan: json['jenis_kendaraan'] as String,
      muatan: json['muatan'] as String,
      fotoSelfiePath: json['foto_selfie_path'] as String?,
      fotoSelfieUrl: json['foto_selfie_url'] as String?,
      tarif: json['tarif'] as int? ?? 0,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      isSynced: json['is_synced'] as bool? ?? false,
      syncRetryCount: json['sync_retry_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'kendaraan_ke': kendaraanKe,
      'no_polisi': noPolisi,
      'golongan': golongan,
      'jenis_kendaraan': jenisKendaraan,
      'muatan': muatan,
      'foto_selfie_path': fotoSelfiePath,
      'foto_selfie_url': fotoSelfieUrl,
      'tarif': tarif,
      'lat': lat,
      'lng': lng,
      'created_at': createdAt.toIso8601String(),
      'is_synced': isSynced,
      'sync_retry_count': syncRetryCount,
    };
  }

  VehicleModel copyWith({
    String? id,
    String? tripId,
    int? kendaraanKe,
    String? noPolisi,
    String? golongan,
    String? jenisKendaraan,
    String? muatan,
    String? fotoSelfiePath,
    String? fotoSelfieUrl,
    int? tarif,
    double? lat,
    double? lng,
    bool? isSynced,
    int? syncRetryCount,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      kendaraanKe: kendaraanKe ?? this.kendaraanKe,
      noPolisi: noPolisi ?? this.noPolisi,
      golongan: golongan ?? this.golongan,
      jenisKendaraan: jenisKendaraan ?? this.jenisKendaraan,
      muatan: muatan ?? this.muatan,
      fotoSelfiePath: fotoSelfiePath ?? this.fotoSelfiePath,
      fotoSelfieUrl: fotoSelfieUrl ?? this.fotoSelfieUrl,
      tarif: tarif ?? this.tarif,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      createdAt: createdAt,
      isSynced: isSynced ?? this.isSynced,
      syncRetryCount: syncRetryCount ?? this.syncRetryCount,
    );
  }
}