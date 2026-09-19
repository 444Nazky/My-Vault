import 'package:hive/hive.dart';
import 'user_model.dart';
import 'trip_model.dart';
import 'vehicle_model.dart';
import 'tariff_model.dart';
import 'region_model.dart';

class HiveAdapters {
  static void registerAdapters() {
    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TripModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(VehicleModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TariffModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(RegionModelAdapter());
    }
  }
}

// User Model Adapter
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserModel(
      id: fields[0] as String,
      nama: fields[1] as String,
      regionId: fields[2] as String,
      deviceId: fields[3] as String,
      role: fields[4] as String?,
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeByte(6);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nama);
    writer.writeByte(2);
    writer.write(obj.regionId);
    writer.writeByte(3);
    writer.write(obj.deviceId);
    writer.writeByte(4);
    writer.write(obj.role);
    writer.writeByte(5);
    writer.write(obj.createdAt);
  }
}

// Trip Model Adapter
class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 1;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return TripModel(
      id: fields[0] as String,
      noTrip: fields[1] as String,
      userId: fields[2] as String,
      regionId: fields[3] as String,
      rute: fields[4] as String?,
      statusMuatan: fields[5] as String,
      keterangan: fields[6] as String?,
      fotoKondisiPath: fields[7] as String?,
      startLat: fields[8] as double,
      startLng: fields[9] as double,
      endLat: fields[10] as double?,
      endLng: fields[11] as double?,
      createdAt: fields[12] as DateTime?,
      completedAt: fields[13] as DateTime?,
      vehicles: (fields[14] as List?)?.cast<VehicleModel>(),
      isSynced: fields[15] as bool,
      syncRetryCount: fields[16] as int,
      status: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer.writeByte(18);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.noTrip);
    writer.writeByte(2);
    writer.write(obj.userId);
    writer.writeByte(3);
    writer.write(obj.regionId);
    writer.writeByte(4);
    writer.write(obj.rute);
    writer.writeByte(5);
    writer.write(obj.statusMuatan);
    writer.writeByte(6);
    writer.write(obj.keterangan);
    writer.writeByte(7);
    writer.write(obj.fotoKondisiPath);
    writer.writeByte(8);
    writer.write(obj.startLat);
    writer.writeByte(9);
    writer.write(obj.startLng);
    writer.writeByte(10);
    writer.write(obj.endLat);
    writer.writeByte(11);
    writer.write(obj.endLng);
    writer.writeByte(12);
    writer.write(obj.createdAt);
    writer.writeByte(13);
    writer.write(obj.completedAt);
    writer.writeByte(14);
    writer.write(obj.vehicles);
    writer.writeByte(15);
    writer.write(obj.isSynced);
    writer.writeByte(16);
    writer.write(obj.syncRetryCount);
    writer.writeByte(17);
    writer.write(obj.status);
  }
}

// Vehicle Model Adapter
class VehicleModelAdapter extends TypeAdapter<VehicleModel> {
  @override
  final int typeId = 2;

  @override
  VehicleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return VehicleModel(
      id: fields[0] as String,
      tripId: fields[1] as String,
      kendaraanKe: fields[2] as int,
      noPolisi: fields[3] as String,
      golongan: fields[4] as String,
      jenisKendaraan: fields[5] as String,
      muatan: fields[6] as String,
      fotoSelfiePath: fields[7] as String?,
      fotoSelfieUrl: fields[8] as String?,
      tarif: fields[9] as int,
      lat: fields[10] as double,
      lng: fields[11] as double,
      createdAt: fields[12] as DateTime?,
      isSynced: fields[13] as bool,
      syncRetryCount: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleModel obj) {
    writer.writeByte(15);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.tripId);
    writer.writeByte(2);
    writer.write(obj.kendaraanKe);
    writer.writeByte(3);
    writer.write(obj.noPolisi);
    writer.writeByte(4);
    writer.write(obj.golongan);
    writer.writeByte(5);
    writer.write(obj.jenisKendaraan);
    writer.writeByte(6);
    writer.write(obj.muatan);
    writer.writeByte(7);
    writer.write(obj.fotoSelfiePath);
    writer.writeByte(8);
    writer.write(obj.fotoSelfieUrl);
    writer.writeByte(9);
    writer.write(obj.tarif);
    writer.writeByte(10);
    writer.write(obj.lat);
    writer.writeByte(11);
    writer.write(obj.lng);
    writer.writeByte(12);
    writer.write(obj.createdAt);
    writer.writeByte(13);
    writer.write(obj.isSynced);
    writer.writeByte(14);
    writer.write(obj.syncRetryCount);
  }
}

// Tariff Model Adapter
class TariffModelAdapter extends TypeAdapter<TariffModel> {
  @override
  final int typeId = 3;

  @override
  TariffModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return TariffModel(
      id: fields[0] as String,
      golongan: fields[1] as String,
      jenisKendaraan: fields[2] as String,
      tarifMuatan: fields[3] as int,
      tarifTanpaMuatan: fields[4] as int,
      regionId: fields[5] as String?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, TariffModel obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.golongan);
    writer.writeByte(2);
    writer.write(obj.jenisKendaraan);
    writer.writeByte(3);
    writer.write(obj.tarifMuatan);
    writer.writeByte(4);
    writer.write(obj.tarifTanpaMuatan);
    writer.writeByte(5);
    writer.write(obj.regionId);
    writer.writeByte(6);
    writer.write(obj.updatedAt);
  }
}

// Region Model Adapter
class RegionModelAdapter extends TypeAdapter<RegionModel> {
  @override
  final int typeId = 4;

  @override
  RegionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return RegionModel(
      id: fields[0] as String,
      nama: fields[1] as String,
      kode: fields[2] as String,
      batasLatMin: fields[3] as double,
      batasLatMax: fields[4] as double,
      batasLngMin: fields[5] as double,
      batasLngMax: fields[6] as double,
      isActive: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RegionModel obj) {
    writer.writeByte(8);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.nama);
    writer.writeByte(2);
    writer.write(obj.kode);
    writer.writeByte(3);
    writer.write(obj.batasLatMin);
    writer.writeByte(4);
    writer.write(obj.batasLatMax);
    writer.writeByte(5);
    writer.write(obj.batasLngMin);
    writer.writeByte(6);
    writer.write(obj.batasLngMax);
    writer.writeByte(7);
    writer.write(obj.isActive);
  }
}