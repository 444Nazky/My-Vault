import 'package:hive/hive.dart';

part 'tariff_model.g.dart';

@HiveType(typeId: 3)
class TariffModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String golongan; // 'internal', 'eksternal'

  @HiveField(2)
  String jenisKendaraan; // 'truk', 'mobil', 'motor'

  @HiveField(3)
  int tarifMuatan; // Tarif dengan muatan

  @HiveField(4)
  int tarifTanpaMuatan; // Tarif tanpa muatan

  @HiveField(5)
  String? regionId; // null = tarif global

  @HiveField(6)
  DateTime updatedAt;

  TariffModel({
    required this.id,
    required this.golongan,
    required this.jenisKendaraan,
    required this.tarifMuatan,
    required this.tarifTanpaMuatan,
    this.regionId,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  // Hitung tarif berdasarkan status muatan
  int hitungTarif(bool denganMuatan) {
    return denganMuatan ? tarifMuatan : tarifTanpaMuatan;
  }

  // Format tarif
  static String formatTarif(int tarif) {
    return 'Rp ${tarif.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get tarifMuatanFormatted => formatTarif(tarifMuatan);
  String get tarifTanpaMuatanFormatted => formatTarif(tarifTanpaMuatan);

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

  factory TariffModel.fromJson(Map<String, dynamic> json) {
    return TariffModel(
      id: json['id'] as String,
      golongan: json['golongan'] as String,
      jenisKendaraan: json['jenis_kendaraan'] as String,
      tarifMuatan: json['tarif_muatan'] as int,
      tarifTanpaMuatan: json['tarif_tanpa_muatan'] as int,
      regionId: json['region_id'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'golongan': golongan,
      'jenis_kendaraan': jenisKendaraan,
      'tarif_muatan': tarifMuatan,
      'tarif_tanpa_muatan': tarifTanpaMuatan,
      'region_id': regionId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}