import 'package:flutter/material.dart';
import '../data/models/trip_model.dart';
import '../core/constants/app_constants.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onTap;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
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
            // Header
            Row(
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    trip.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Trip number
                Text(
                  trip.noTrip,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Info row
            Row(
              children: [
                // Date
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${trip.createdAt.day}/${trip.createdAt.month}/${trip.createdAt.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                // Vehicle count
                Icon(Icons.directions_car, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${trip.vehicleCount} kendaraan',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Bottom row
            Row(
              children: [
                // Muatan status
                Icon(
                  trip.isKosong ? Icons.inbox : Icons.inventory,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  trip.isKosong ? 'Kosong' : 'Ada Muatan',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                // Total tarif
                Text(
                  'Rp ${trip.totalTarif.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
              ],
            ),
            
            // Sync indicator
            if (!trip.isSynced) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Color(AppConstants.warningColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sync,
                      size: 12,
                      color: Color(AppConstants.warningColor),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Belum tersinkron',
                      style: TextStyle(
                        color: Color(AppConstants.warningColor),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (trip.status) {
      case AppConstants.tripStatusActive:
        return Color(AppConstants.successColor);
      case AppConstants.tripStatusCompleted:
        return Color(AppConstants.primaryColor);
      case AppConstants.tripStatusFailed:
        return Color(AppConstants.errorColor);
      default:
        return Colors.grey;
    }
  }
}

class VehicleCard extends StatelessWidget {
  final dynamic vehicle;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: Container(
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
            // Vehicle number
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(AppConstants.primaryColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '#${vehicle.kendaraanKe}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            
            // Vehicle info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.noPolisi,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vehicle.golonganLabel} • ${vehicle.jenisLabel}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tarif
            Text(
              vehicle.tarifFormatted,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.successColor),
              ),
            ),
            
            // Sync indicator
            if (!vehicle.isSynced) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.sync,
                size: 16,
                color: Color(AppConstants.warningColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}