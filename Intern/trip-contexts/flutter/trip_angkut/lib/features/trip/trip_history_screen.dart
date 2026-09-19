import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'trip_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/trip_card.dart';
import '../../widgets/loading_indicator.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppConstants.backgroundColor),
      appBar: AppBar(
        title: const Text('Riwayat Trip'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, _) {
          if (tripProvider.isLoading) {
            return const LoadingIndicator(message: 'Memuat riwayat...');
          }

          final trips = tripProvider.trips;

          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat trip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Buat trip baru untuk mulai mencatat',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TripCard(
                  trip: trip,
                  onTap: () {
                    Navigator.pushNamed(context, '/trip-detail');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}