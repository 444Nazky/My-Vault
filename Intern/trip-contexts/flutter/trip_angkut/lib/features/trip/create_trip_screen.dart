import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trip_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/camera_service.dart';
import '../../widgets/loading_indicator.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  String _statusMuatan = AppConstants.statusMuatanAda;
  final TextEditingController _keteranganController = TextEditingController();
  String? _fotoKondisiPath;
  final CameraService _cameraService = CameraService();
  bool _isLoading = false;

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColor),
      appBar: AppBar(
        title: const Text('Buat Trip Baru'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Muatan
            _buildStatusMuatanSection(),
            
            const SizedBox(height: 24),
            
            // Keterangan (jika kosong)
            if (_statusMuatan == AppConstants.statusMuatanKosong)
              _buildKeteranganSection(),
            
            if (_statusMuatan == AppConstants.statusMuatanKosong)
              const SizedBox(height: 24),
            
            // Foto Kondisi (jika kosong)
            if (_statusMuatan == AppConstants.statusMuatanKosong)
              _buildFotoSection(),
            
            if (_statusMuatan == AppConstants.statusMuatanKosong)
              const SizedBox(height: 24),
            
            // GPS Location
            _buildGPSSection(),
            
            const SizedBox(height: 32),
            
            // Submit button
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMuatanSection() {
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
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildMuatanOption(
                  label: 'Ada Muatan',
                  icon: Icons.inventory,
                  value: AppConstants.statusMuatanAda,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMuatanOption(
                  label: 'Kosong',
                  icon: Icons.inbox,
                  value: AppConstants.statusMuatanKosong,
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
    required IconData icon,
    required String value,
  }) {
    final isSelected = _statusMuatan == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _statusMuatan = value;
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
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Color(AppConstants.primaryColor)
                  : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
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

  Widget _buildKeteranganSection() {
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
                'Keterangan',
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
          TextField(
            controller: _keteranganController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Masukkan keterangan kondisi kosong...',
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
                'Foto Kondisi',
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
          
          if (_fotoKondisiPath != null)
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(
                        const [] as dynamic, // Will be replaced with actual image
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _fotoKondisiPath = null;
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
                      'Ambil Foto',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
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

  Widget _buildGPSSection() {
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
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(AppConstants.successColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AKTIF',
                  style: TextStyle(
                    color: Color(AppConstants.successColor),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Koordinat akan diambil otomatis saat trip dibuat',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
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
                'Buat Trip',
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
    final result = await _cameraService.takePhoto(
      prefix: 'trip_condition',
    );

    if (result.success && result.path != null) {
      setState(() {
        _fotoKondisiPath = result.path;
      });
    }
  }

  Future<void> _onSubmit() async {
    // Validasi jika kosong
    if (_statusMuatan == AppConstants.statusMuatanKosong) {
      if (_keteranganController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keterangan wajib diisi untuk kondisi kosong'),
            backgroundColor: Color(AppConstants.errorColor),
          ),
        );
        return;
      }

      if (_fotoKondisiPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto kondisi wajib diambil untuk kondisi kosong'),
            backgroundColor: Color(AppConstants.errorColor),
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    final tripProvider = context.read<TripProvider>();
    final success = await tripProvider.createTrip(
      statusMuatan: _statusMuatan,
      keterangan: _keteranganController.text.trim(),
      fotoKondisiPath: _fotoKondisiPath,
    );

    setState(() {
      _isLoading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip berhasil dibuat'),
          backgroundColor: Color(AppConstants.successColor),
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tripProvider.error ?? 'Gagal membuat trip'),
          backgroundColor: Color(AppConstants.errorColor),
        ),
      );
    }
  }
}