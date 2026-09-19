import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../trip/trip_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/camera_service.dart';
import '../../core/services/location_service.dart';
import '../../data/repositories/tariff_repository.dart';
import '../../widgets/loading_indicator.dart';

class InputVehicleScreen extends StatefulWidget {
  const InputVehicleScreen({super.key});

  @override
  State<InputVehicleScreen> createState() => _InputVehicleScreenState();
}

class _InputVehicleScreenState extends State<InputVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _platNomorController = TextEditingController();
  
  String _golongan = AppConstants.golonganEksternal;
  String _jenisKendaraan = AppConstants.jenisTruk;
  String _muatan = AppConstants.muatanAda;
  
  final CameraService _cameraService = CameraService();
  final LocationService _locationService = LocationService();
  final TariffRepository _tariffRepository = TariffRepository(
    // Will be injected via Provider
    null as dynamic,
  );
  
  String? _fotoSelfiePath;
  bool _isLoading = false;
  double? _currentLat;
  double? _currentLng;
  int _calculatedTarif = 0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _updateTarif();
  }

  @override
  void dispose() {
    _platNomorController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan lokasi: $e'),
            backgroundColor: Color(AppConstants.errorColor),
          ),
        );
      }
    }
  }

  void _updateTarif() {
    // Calculate tarif based on selection
    if (_golongan == 'eksternal') {
      if (_jenisKendaraan == 'truk') {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 120000 : 80000;
      } else if (_jenisKendaraan == 'mobil') {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 80000 : 60000;
      } else {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 40000 : 25000;
      }
    } else {
      if (_jenisKendaraan == 'truk') {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 100000 : 60000;
      } else if (_jenisKendaraan == 'mobil') {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 60000 : 40000;
      } else {
        _calculatedTarif = _muatan == 'dengan_muatan' ? 30000 : 20000;
      }
    }
  }

  String get _formattedTarif {
    return 'Rp ${_calculatedTarif.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final tripProvider = context.watch<TripProvider>();
    final activeTrip = tripProvider.activeTrip;

    if (activeTrip == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Input Kendaraan'),
          backgroundColor: Color(AppConstants.primaryColor),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Tidak ada trip aktif'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColor),
      appBar: AppBar(
        title: const Text('Input Kendaraan'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip info header
              _buildTripHeader(activeTrip),
              
              const SizedBox(height: 24),
              
              // Plat Nomor
              _buildPlatNomorField(),
              
              const SizedBox(height: 16),
              
              // Golongan
              _buildGolonganSection(),
              
              const SizedBox(height: 16),
              
              // Jenis Kendaraan
              _buildJenisKendaraanSection(),
              
              const SizedBox(height: 16),
              
              // Status Muatan
              _buildMuatanSection(),
              
              const SizedBox(height: 16),
              
              // Tarif
              _buildTarifSection(),
              
              const SizedBox(height: 16),
              
              // Foto Selfie
              _buildFotoSection(),
              
              const SizedBox(height: 16),
              
              // Lokasi GPS
              _buildLocationSection(),
              
              const SizedBox(height: 32),
              
              // Submit button
              _buildSubmitButton(tripProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTripHeader(dynamic trip) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(AppConstants.successColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trip.noTrip,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            trip.statusMuatan == 'ada_muatan' ? 'Ada Muatan' : 'Kosong',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            '${trip.vehicleCount} kendaraan',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatNomorField() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plat Nomor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _platNomorController,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: 'Contoh: B 1234 ABC',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(AppConstants.primaryColor),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Plat nomor wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGolonganSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Golongan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGolonganOption(
                  label: 'Internal',
                  value: AppConstants.golonganInternal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGolonganOption(
                  label: 'Eksternal',
                  value: AppConstants.golonganEksternal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGolonganOption({
    required String label,
    required String value,
  }) {
    final isSelected = _golongan == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _golongan = value;
          _updateTarif();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(AppConstants.primaryColor).withOpacity(0.1)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected
                ? Color(AppConstants.primaryColor)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Color(AppConstants.primaryColor)
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJenisKendaraanSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Kendaraan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildJenisOption(
                  icon: Icons.local_shipping,
                  label: 'Truk',
                  value: AppConstants.jenisTruk,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildJenisOption(
                  icon: Icons.directions_car,
                  label: 'Mobil',
                  value: AppConstants.jenisMobil,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildJenisOption(
                  icon: Icons.two_wheeler,
                  label: 'Motor',
                  value: AppConstants.jenisMotor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJenisOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isSelected = _jenisKendaraan == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _jenisKendaraan = value;
          _updateTarif();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(AppConstants.primaryColor).withOpacity(0.1)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected
                ? Color(AppConstants.primaryColor)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Color(AppConstants.primaryColor)
                  : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Color(AppConstants.primaryColor)
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuatanSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Muatan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMuatanOption(
                  label: 'Dengan Muatan',
                  value: AppConstants.muatanAda,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMuatanOption(
                  label: 'Tanpa Muatan',
                  value: AppConstants.muatanKosong,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMuatanOption({
    required String label,
    required String value,
  }) {
    final isSelected = _muatan == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _muatan = value;
          _updateTarif();
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(AppConstants.successColor).withOpacity(0.1)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected
                ? Color(AppConstants.successColor)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Color(AppConstants.successColor)
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTarifSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tarif',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(AppConstants.accentColor).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Tarif',
                  style: TextStyle(
                    color: Color(AppConstants.accentColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _formattedTarif,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFotoSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Foto Selfie Kendaraan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(AppConstants.errorColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Wajib',
                  style: TextStyle(
                    color: Color(AppConstants.errorColor),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_fotoSelfiePath != null)
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 48, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _fotoSelfiePath = null;
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            )
          else
            InkWell(
              onTap: _takePhoto,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ambil Foto Selfie',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pastikan kendaraan terlihat jelas',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(AppConstants.successColor)),
              const SizedBox(width: 8),
              const Text(
                'Lokasi GPS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_currentLat != null && _currentLng != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(AppConstants.successColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(AppConstants.successColor),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Lat: ${_currentLat!.toStringAsFixed(6)}, Lng: ${_currentLng!.toStringAsFixed(6)}',
                      style: const TextStyle(
                        color: Color(AppConstants.successColor),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Mendapatkan lokasi...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(TripProvider tripProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(AppConstants.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Simpan Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    final result = await _cameraService.takeVehicleSelfie();

    if (result.success && result.path != null) {
      setState(() {
        _fotoSelfiePath = result.path;
      });
    }
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validasi foto
    if (_fotoSelfiePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto selfie kendaraan wajib diambil'),
          backgroundColor: Color(AppConstants.errorColor),
        ),
      );
      return;
    }

    // Validasi lokasi
    if (_currentLat == null || _currentLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi GPS belum tersedia'),
          backgroundColor: Color(AppConstants.errorColor),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final tripProvider = context.read<TripProvider>();
    final success = await tripProvider.addVehicle(
      noPolisi: _platNomorController.text.trim().toUpperCase(),
      golongan: _golongan,
      jenisKendaraan: _jenisKendaraan,
      muatan: _muatan,
      fotoSelfiePath: _fotoSelfiePath,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendaraan berhasil ditambahkan'),
          backgroundColor: Color(AppConstants.successColor),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tripProvider.error ?? 'Gagal menambahkan kendaraan'),
          backgroundColor: Color(AppConstants.errorColor),
        ),
      );
    }
  }
}