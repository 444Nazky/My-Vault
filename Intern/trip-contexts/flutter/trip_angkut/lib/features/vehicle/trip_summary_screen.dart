import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../trip/trip_provider.dart';
import '../../core/constants/app_constants.dart';

class TripSummaryScreen extends StatelessWidget {
  const TripSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColor),
      appBar: AppBar(
        title: const Text('Ringkasan Trip'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          // Get the last completed trip
          final trips = tripProvider.trips;
          final completedTrips = trips.where(
            (t) => t.status == AppConstants.tripStatusCompleted,
          ).toList();

          if (completedTrips.isEmpty) {
            return const Center(
              child: Text('Tidak ada trip selesai'),
            );
          }

          final lastTrip = completedTrips.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Success icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(AppConstants.successColor).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: 64,
                    color: Color(AppConstants.successColor),
                  ),
                ),
                const SizedBox(height: 16),
                
                const Text(
                  'Trip Selesai!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  lastTrip.noTrip,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Summary card
                _buildSummaryCard(lastTrip),
                
                const SizedBox(height: 24),
                
                // Back to home button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(AppConstants.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Kembali ke Beranda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(dynamic trip) {
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
        children: [
          _buildSummaryRow(
            icon: Icons.directions_car,
            label: 'Total Kendaraan',
            value: '${trip.vehicleCount}',
          ),
          const Divider(),
          _buildSummaryRow(
            icon: Icons.attach_money,
            label: 'Total Tarif',
            value: 'Rp ${trip.totalTarif.toStringAsFixed(0)}',
            valueColor: Color(AppConstants.successColor),
          ),
          const Divider(),
          _buildSummaryRow(
            icon: Icons.calendar_today,
            label: 'Tanggal',
            value: '${trip.createdAt.day}/${trip.createdAt.month}/${trip.createdAt.year}',
          ),
          const Divider(),
          _buildSummaryRow(
            icon: Icons.access_time,
            label: 'Durasi',
            value: _calculateDuration(trip.createdAt, trip.completedAt),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime? end) {
    if (end == null) return '-';
    
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes}m';
  }
}