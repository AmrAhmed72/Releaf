import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = 'bd68ac0c-1024-4314-82ef-eb7bb5c9498e'; // Replace with your AirVisual API key
  List<Country> countries = [];
  List<City> cities = [];
  List<Marker> cityMarkers = [];
  City? selectedCity;
  AirQualityData? selectedCityData;
  LatLng? customMarkerLocation; // To store the user-selected location
  bool isLoading = false;
  final MapController _mapController = MapController(); // Add a MapController to control the map

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  // Fetch the list of countries
  Future<void> _fetchCountries() async {
    final url = Uri.parse('http://api.airvisual.com/v2/countries?key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            countries = (data['data'] as List)
                .map((country) => Country.fromJson(country))
                .toList();
            // For demo purposes, let's fetch cities for the first country
            if (countries.isNotEmpty) {
              _fetchCitiesForCountry(countries[0].name);
            }
          });
        }
      } else {
        print('Failed to fetch countries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }

  // Fetch cities for a specific country (using a hardcoded state for simplicity)
  Future<void> _fetchCitiesForCountry(String country) async {
    // For demo, let's use a hardcoded state (e.g., California for USA)
    final url = Uri.parse(
        'http://api.airvisual.com/v2/cities?state=California&country=$country&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            cities = (data['data'] as List)
                .map((city) => City.fromJson(city, country, 'California'))
                .toList();
            _fetchCityCoordinates();
          });
        }
      } else {
        print('Failed to fetch cities: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  // Fetch coordinates for each city and create markers
  Future<void> _fetchCityCoordinates() async {
    List<Marker> markers = [];
    for (var city in cities) {
      final url = Uri.parse(
          'http://api.airvisual.com/v2/city?city=${city.name}&state=${city.state}&country=${city.country}&key=$apiKey');
      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == 'success') {
            final coords = data['data']['location']['coordinates'];
            final latLng = LatLng(coords[1], coords[0]); // [longitude, latitude]
            markers.add(
              Marker(
                point: latLng,
                child: GestureDetector(
                  onTap: () {
                    _fetchCityData(city);
                  },
                  child: const Icon(
                    Icons.location_on_sharp,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ),
            );
          }
        }
      } catch (e) {
        print('Error fetching coordinates for ${city.name}: $e');
      }
    }
    setState(() {
      cityMarkers = markers;
    });
  }

  // Fetch the nearest city based on the custom marker location
  Future<void> _fetchNearestCity(double lat, double lon) async {
    final url = Uri.parse(
        'http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final cityData = data['data'];
          setState(() {
            selectedCity = City(
              name: cityData['city'],
              state: cityData['state'],
              country: cityData['country'],
            );
            selectedCityData = AirQualityData.fromJson(cityData);
          });
        }
      } else {
        print('Failed to fetch nearest city: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearest city: $e');
    }
  }

  // Fetch air quality data for a specific city
  Future<void> _fetchCityData(City city) async {
    setState(() {
      isLoading = true;
      selectedCity = city;
      selectedCityData = null;
    });

    final url = Uri.parse(
        'http://api.airvisual.com/v2/city?city=${city.name}&state=${city.state}&country=${city.country}&key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            selectedCityData = AirQualityData.fromJson(data['data']);
            isLoading = false;
          });
        }
      } else {
        print('Failed to fetch city data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching city data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch the user's current location and update the marker
  Future<void> _selectCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    // Get the current position
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        customMarkerLocation = newLocation;
      });

      // Center the map on the current location
      _mapController.move(newLocation, 10); // Zoom level 10 for better visibility

      // Fetch the nearest city data for the current location
      _fetchNearestCity(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting current location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality Map'),
        backgroundColor: const Color(0xFF609254),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController, // Assign the MapController
            options: MapOptions(
              initialCenter: customMarkerLocation ?? LatLng(31.2357116, 30.0444196), // Default to San Francisco
              initialZoom: 5,
              onTap: (tapPosition, point) {
                // Update the custom marker location when the user taps on the map
                setState(() {
                  customMarkerLocation = point;
                });
                // Fetch the nearest city data for the tapped location
                _fetchNearestCity(point.latitude, point.longitude);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app', // Required by OpenTopoMap
                // Add attribution for OpenTopoMap
                additionalOptions: {
                  'attribution':
                  'Map data: © OpenTopoMap (CC-BY-SA), © OpenStreetMap contributors',
                },
              ),
              MarkerLayer(markers: cityMarkers),
              if (customMarkerLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: customMarkerLocation!,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          if (selectedCity != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${selectedCity!.name}, ${selectedCity!.state}, ${selectedCity!.country}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (selectedCityData != null) ...[
                      Text('AQI: ${selectedCityData!.aqi}'),
                      Text('Temperature: ${selectedCityData!.temperature} °C'),
                      Text('Humidity: ${selectedCityData!.humidity}%'),
                      Text('Wind Speed: ${selectedCityData!.windSpeed} m/s'),
                    ] else
                      const Text('Failed to load air quality data.'),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectCurrentLocation,
        backgroundColor: const Color(0xFF609254),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}

// Models for API data
class Country {
  final String name;

  Country({required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(name: json['country']);
  }
}

class City {
  final String name;
  final String state;
  final String country;

  City({required this.name, required this.state, required this.country});

  factory City.fromJson(Map<String, dynamic> json, String country, String state) {
    return City(
      name: json['city'],
      state: state,
      country: country,
    );
  }
}

class AirQualityData {
  final int aqi;
  final double temperature;
  final int humidity;
  final double windSpeed;

  AirQualityData({
    required this.aqi,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    return AirQualityData(
      aqi: current['pollution']['aqius'],
      temperature: current['weather']['tp'].toDouble(),
      humidity: current['weather']['hu'],
      windSpeed: current['weather']['ws'].toDouble(),
    );
  }
}