import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Variabel untuk menyimpan nama kota berdasarkan koordinat lokasi
  String city = '';
  // Variabel untuk menyimpan nilai lintang dan bujur
  double lat = 0.0;
  double lng = 0.0;
  // Variabel untuk menyimpan catatan lokasi
  String note = '';

  // Kontroler untuk mengatur peta
  late final MapController _mapController = MapController();

  // Membuat marker pada lokasi yang ditentukan
  Marker buildMarker(LatLng coordinates) {
    return Marker(
      point: LatLng(coordinates.latitude, coordinates.longitude),
      child: const Icon(
        CupertinoIcons.location_solid,
        color: Colors.purple,
        size: 38,
      ),
    );
  }

  // Mendapatkan lokasi saat ini menggunakan Geolocator
  Future<void> _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    // Mendapatkan nama kota berdasarkan koordinat
    _getCityFromCoordinates(lat, lng);
    // Memindahkan peta ke lokasi saat ini
    _mapController.move(LatLng(lat, lng), 16.0);
  }

  // Mendapatkan nama kota dari koordinat menggunakan Geocoding
  Future<void> _getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      setState(() {
        city =
            '${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}';
      });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Mendapatkan lokasi saat ini saat inisialisasi
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.grey.shade200),
                  ),
                  onPressed: () async {
                    // Menggunakan lokasi saat ini
                    await _getCurrentLocation();
                  },
                  icon: const Icon(
                    CupertinoIcons.location,
                    size: 14,
                  ),
                  label: const Text("Use my location"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.purple),
                  ),
                  onPressed: () {
                    setState(() {
                      // Aktifkan interaksi peta
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.map,
                    color: Colors.white,
                    size: 14,
                  ),
                  label: const Text(
                    "Choose on map",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Menampilkan nama kota jika tersedia
          if (city.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.map_pin_ellipse,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    city,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          // Input untuk catatan lokasi
          TextField(
            decoration: const InputDecoration(
              labelText: 'Location Note',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                note = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Peta untuk memilih lokasi
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(lat, lng),
                  initialZoom: 16.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      // Mengupdate lokasi berdasarkan titik yang dipilih di peta
                      lat = point.latitude;
                      lng = point.longitude;
                      _getCityFromCoordinates(lat, lng);
                    });
                  },
                ),
                children: [
                  // Menampilkan peta menggunakan OpenStreetMap
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  // Menampilkan marker pada lokasi yang dipilih
                  MarkerLayer(
                    markers: [
                      buildMarker(LatLng(lat, lng)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Tombol untuk mengirim lokasi
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {'city': city, 'note': note});
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
