import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core
import 'core/constants/app_constants.dart';
import 'core/services/storage_service.dart';
import 'core/services/location_service.dart';
import 'core/services/camera_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/auth_service.dart';
import 'core/services/sync_service.dart';

// Repositories
import 'data/repositories/auth_repository.dart';
import 'data/repositories/trip_repository.dart';
import 'data/repositories/tariff_repository.dart';

// Providers
import 'features/auth/auth_provider.dart';
import 'features/trip/trip_provider.dart';

// Screens
import 'features/auth/login_screen.dart';
import 'features/trip/home_screen.dart';
import 'features/trip/create_trip_screen.dart';
import 'features/vehicle/input_vehicle_screen.dart';

// Widgets
import 'widgets/loading_indicator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = StorageService();
  await storageService.init();

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        Provider<StorageService>.value(value: storageService),
        Provider<LocationService>(create: (_) => LocationService()),
        Provider<CameraService>(create: (_) => CameraService()),
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
          dispose: (_, service) => service.dispose(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(storageService),
        ),

        // Repositories
        ProxyProvider<StorageService, AuthRepository>(
          update: (_, storage, __) => AuthRepository(storage),
        ),
        ProxyProvider2<StorageService, ConnectivityService, TripRepository>(
          update: (_, storage, connectivity, __) =>
              TripRepository(storage, connectivity),
        ),
        ProxyProvider<StorageService, TariffRepository>(
          update: (_, storage, __) => TariffRepository(storage),
        ),

        // Providers
        ChangeProxyProvider<AuthRepository, AuthProvider>(
          create: (_) => AuthProvider(
            AuthRepository(storageService),
            AuthService(storageService),
          ),
          update: (_, authRepo, previous) => AuthProvider(
            authRepo,
            AuthService(storageService),
          ),
        ),
        ChangeProxyProvider2<TripRepository, TariffRepository, TripProvider>(
          create: (_) => TripProvider(
            TripRepository(storageService, ConnectivityService()),
            TariffRepository(storageService),
            LocationService(),
          ),
          update: (_, tripRepo, tariffRepo, previous) => TripProvider(
            tripRepo,
            tariffRepo,
            LocationService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(AppConstants.primaryColor),
          scaffoldBackgroundColor: Color(AppConstants.backgroundColor),
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(AppConstants.primaryColor),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
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
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/create-trip': (context) => const CreateTripScreen(),
          '/input-vehicle': (context) => const InputVehicleScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check auth status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: LoadingIndicator(message: 'Memuat...'),
          );
        }

        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}