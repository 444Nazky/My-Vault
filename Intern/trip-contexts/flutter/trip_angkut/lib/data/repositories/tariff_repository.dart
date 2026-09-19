import 'package:dio/dio.dart';
import '../models/tariff_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';

class TariffRepository {
  final StorageService _storageService;
  final Dio _dio;

  TariffRepository(this._storageService)
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: AppConstants.apiTimeout,
          receiveTimeout: AppConstants.apiTimeout,
        ));

  // Get all tariffs
  Future<List<TariffModel>> getAllTariffs({String? regionId}) async {
    try {
      // Coba ambil dari server
      final response = await _dio.get(
        ApiConstants.adminTariffs,
        queryParameters: {
          if (regionId != null) ApiConstants.queryRegionId: regionId,
        },
      );

      if (response.data[ApiConstants.keySuccess] == true) {
        final data = response.data[ApiConstants.keyData];
        final tariffs = (data as List)
            .map((t) => TariffModel.fromJson(t))
            .toList();

        // Simpan ke local storage
        await _storageService.saveAllTariffs(tariffs);

        return tariffs;
      }
    } catch (e) {
      print('Failed to fetch tariffs from server: $e');
    }

    // Fallback ke local storage
    return _storageService.getAllTariffs().cast<TariffModel>();
  }

  // Hitung tarif berdasarkan kombinasi
  int calculateTarif({
    required String golongan,
    required String jenisKendaraan,
    required bool denganMuatan,
    String? regionId,
  }) {
    final tariff = _storageService.getTariff(
      golongan,
      jenisKendaraan,
      regionId: regionId,
    );

    if (tariff == null) {
      // Default tarif jika tidak ditemukan
      return _getDefaultTarif(golongan, jenisKendaraan, denganMuatan);
    }

    return denganMuatan ? tariff.tarifMuatan : tariff.tarifTanpaMuatan;
  }

  // Get tarif untuk kombinasi tertentu
  TariffModel? getTarif({
    required String golongan,
    required String jenisKendaraan,
    String? regionId,
  }) {
    return _storageService.getTariff(golongan, jenisKendaraan, regionId: regionId);
  }

  // Default tarif jika tidak ada di database
  int _getDefaultTarif(String golongan, String jenisKendaraan, bool denganMuatan) {
    // Default tarif berdasarkan dokumentasi
    if (golongan == 'eksternal') {
      if (jenisKendaraan == 'truk') {
        return denganMuatan ? 120000 : 80000;
      } else if (jenisKendaraan == 'mobil') {
        return denganMuatan ? 80000 : 60000;
      } else if (jenisKendaraan == 'motor') {
        return denganMuatan ? 40000 : 25000;
      }
    } else if (golongan == 'internal') {
      if (jenisKendaraan == 'truk') {
        return denganMuatan ? 100000 : 60000;
      } else if (jenisKendaraan == 'mobil') {
        return denganMuatan ? 60000 : 40000;
      } else if (jenisKendaraan == 'motor') {
        return denganMuatan ? 30000 : 20000;
      }
    }

    return 0;
  }

  // Format tarif
  static String formatTarif(int tarif) {
    return 'Rp ${tarif.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Get all available golongan options
  List<String> getGolonganOptions() {
    return [AppConstants.golonganInternal, AppConstants.golonganEksternal];
  }

  // Get all available jenis kendaraan options
  List<String> getJenisKendaraanOptions() {
    return [AppConstants.jenisTruk, AppConstants.jenisMobil, AppConstants.jenisMotor];
  }
}