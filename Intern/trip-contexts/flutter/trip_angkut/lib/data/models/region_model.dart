import 'package:hive/hive.dart';

part 'region_model.g.dart';

@HiveType(typeId: 4)
class RegionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String kode;

  @HiveField(3)
  double batasLatMin;

  @HiveField(4)
  double batasLatMax;

  @HiveField(5)
  double batasLngMin;

  @HiveField(6)
  double batasLngMax;

  @HiveField(7)
  bool isActive;

  RegionModel({
    required this.id,
    required this.nama,
    required this.kode,
    required this.batasLatMin,
    required this.batasLatMax,
    required this.batasLngMin,
    required this.batasLngMax,
    this.isActive = true,
  });

  // Cek apakah koordinat dalam batas region
  bool isWithinBounds(double lat, double lng) {
    return lat >= batasLatMin &&
        lat <= batasLatMax &&
        lng >= batasLngMin &&
        lng <= batasLngMax;
  }

  // Hitung jarak dari titik ke pusat region (dalam km)
  double distanceToCenter(double lat, double lng) {
    final centerLat = (batasLatMin + batasLatMax) / 2;
    final centerLng = (batasLngMin + batasLngMax) / 2;

    // Haversine formula
    final dLat = _toRadians(lat - centerLat);
    final dLng = _toRadians(lng - centerLng);
    final a = (dLat / 2).sin() * (dLat / 2).sin() +
        _toRadians(centerLat).cos() * lat.cos() * (dLng / 2).sin() * (dLng / 2).sin();
    final c = 2 * a.sqrt().asin() / (1 - a).sqrt().clamp(0.0, 1.0).toDouble();
    return 6371 * c;
  }

  double _toRadians(double degree) => degree * 3.141592653589793 / 180;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kode: json['kode'] as String,
      batasLatMin: (json['batas_lat_min'] as num).toDouble(),
      batasLatMax: (json['batas_lat_max'] as num).toDouble(),
      batasLngMin: (json['batas_lng_min'] as num).toDouble(),
      batasLngMax: (json['batas_lng_max'] as num).toDouble(),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kode': kode,
      'batas_lat_min': batasLatMin,
      'batas_lat_max': batasLatMax,
      'batas_lng_min': batasLngMin,
      'batas_lng_max': batasLngMax,
      'is_active': isActive,
    };
  }
}