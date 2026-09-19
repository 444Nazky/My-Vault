import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/sync_service.dart';

class OfflineIndicator extends StatefulWidget {
  final SyncService? syncService;

  const OfflineIndicator({super.key, this.syncService});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isConnected = true;
  SyncStats? _syncStats;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() {
    // For now, assume connected
    // In real app, listen to ConnectivityService
    setState(() {
      _isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show indicator if offline or has pending sync
    if (_isConnected && (_syncStats == null || !_syncStats!.hasPendingData)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isConnected
            ? Color(AppConstants.warningColor)
            : Color(AppConstants.errorColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isConnected ? Icons.sync : Icons.cloud_off,
            size: 16,
            color: _isConnected ? Colors.black87 : Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            _isConnected
                ? '${_syncStats?.pendingTrips ?? 0} pending'
                : 'Offline',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _isConnected ? Colors.black87 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class SyncButton extends StatefulWidget {
  final SyncService syncService;
  final VoidCallback? onSyncComplete;

  const SyncButton({
    super.key,
    required this.syncService,
    this.onSyncComplete,
  });

  @override
  State<SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends State<SyncButton> {
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    // Listen to sync status
    widget.syncService.syncStatus.listen((status) {
      if (mounted) {
        setState(() {
          _isSyncing = status.status == SyncStatusCode.syncing;
        });

        if (status.status == SyncStatusCode.success ||
            status.status == SyncStatusCode.error) {
          widget.onSyncComplete?.call();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isSyncing ? null : _onSync,
      icon: _isSyncing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.sync),
      tooltip: 'Sinkronkan data',
    );
  }

  void _onSync() async {
    setState(() {
      _isSyncing = true;
    });

    await widget.syncService.manualSync();

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sinkronisasi selesai'),
          backgroundColor: Color(AppConstants.successColor),
        ),
      );
    }
  }
}