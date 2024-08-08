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
  // Variable to store the city name based on location coordinates
  String city = '';
  // Variables to store latitude and longitude values
  double lat = 0.0;
  double lng = 0.0;
  // Variable to store location notes
  String note = '';

  // Controller to manage the map
  late final MapController _mapController = MapController();

  // Function to build a marker at the specified location
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

  // Function to get the current location using Geolocator
  Future<void> _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
    // Get the city name based on coordinates
    _getCityFromCoordinates(lat, lng);
    // Move the map to the current location
    _mapController.move(LatLng(lat, lng), 16.0);
  }

  // Function to get city name from coordinates using Geocoding
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
    // Get the current location during initialization
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
                    // Use the current location
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
                      // Enable map interaction
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
          // Display the city name if available
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
          // Input for location notes
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
          // Map for selecting a location
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
                      // Update location based on the selected point on the map
                      lat = point.latitude;
                      lng = point.longitude;
                      _getCityFromCoordinates(lat, lng);
                    });
                  },
                ),
                children: [
                  // Display map using OpenStreetMap
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  // Display a marker at the selected location
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
          // Button to submit the location
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
