import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trip_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/loading_indicator.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColor),
      appBar: AppBar(
        title: const Text('Detail Trip'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          final trip = tripProvider.activeTrip;
          
          if (trip == null) {
            return const Center(
              child: Text('Tidak ada trip aktif'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip header
                _buildTripHeader(trip),
                
                const SizedBox(height: 16),
                
                // Trip info
                _buildTripInfo(trip),
                
                const SizedBox(height: 16),
                
                // Vehicles list
                _buildVehiclesList(trip, tripProvider),
                
                const SizedBox(height: 16),
                
                // Total
                _buildTotalSection(trip),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripHeader(dynamic trip) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(AppConstants.primaryColor),
            Color(AppConstants.primaryColor).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              trip.noTrip,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            trip.statusMuatan == 'ada_muatan' ? 'Ada Muatan' : 'Kosong',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfo(dynamic trip) {
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
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'Tanggal',
            value: '${trip.createdAt.day}/${trip.createdAt.month}/${trip.createdAt.year}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Waktu Mulai',
            value: '${trip.createdAt.hour.toString().padLeft(2, '0')}:${trip.createdAt.minute.toString().padLeft(2, '0')}',
          ),
          if (trip.completedAt != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Waktu Selesai',
              value: '${trip.completedAt!.hour.toString().padLeft(2, '0')}:${trip.completedAt!.minute.toString().padLeft(2, '0')}',
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Lokasi Awal',
            value: '${trip.startLat.toStringAsFixed(6)}, ${trip.startLng.toStringAsFixed(6)}',
          ),
          if (trip.endLat != null && trip.endLng != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Lokasi Akhir',
              value: '${trip.endLat!.toStringAsFixed(6)}, ${trip.endLng!.toStringAsFixed(6)}',
            ),
          ],
          if (trip.keterangan != null && trip.keterangan!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.note,
              label: 'Keterangan',
              value: trip.keterangan!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehiclesList(dynamic trip, TripProvider tripProvider) {
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
                'Kendaraan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(AppConstants.primaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${trip.vehicleCount}',
                  style: TextStyle(
                    color: Color(AppConstants.primaryColor),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (trip.vehicles.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.directions_car, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      'Belum ada kendaraan',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trip.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = trip.vehicles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: VehicleCard(
                    vehicle: vehicle,
                    onTap: () {
                      tripProvider.selectVehicle(index);
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(dynamic trip) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Tarif',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Rp ${trip.totalTarif.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.successColor),
            ),
          ),
        ],
      ),
    );
  }
}