import 'package:e_commerce/providers/service_providers.dart';
import 'package:e_commerce/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cek apakah layanan lokasi diaktifkan
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Layanan lokasi tidak diaktifkan, minta pengguna untuk mengaktifkannya
    // Anda bisa menampilkan dialog atau pesan di sini
    // Misalnya: return; atau handle sesuai kebutuhan
    print('Location services are disabled.');
    return;
  }

  // Cek izin lokasi
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Izin lokasi ditolak, Anda bisa meminta pengguna untuk memberikan izin
      // Misalnya: return; atau handle sesuai kebutuhan
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Izin lokasi ditolak selamanya, Anda bisa meminta pengguna untuk memberikan izin melalui pengaturan
    // Misalnya: return; atau handle sesuai kebutuhan
    print('Location permissions are permanently denied');
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ServiceProviders>(
      create: (_) => ServiceProviders(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
