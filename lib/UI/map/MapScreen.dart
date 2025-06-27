import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../models/Map/AirQualityData.dart';
import '../../models/Map/City.dart';
import '../../models/Map/Country.dart';
import '../../services/Api/api_service.dart';
import '../../models/plant.dart';
import '../../models/category.dart';
import './plant_suggestion_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = 'bd68ac0c-1024-4314-82ef-eb7bb5c9498e';
  List<Country> countries = [];
  List<City> cities = [];
  List<Marker> cityMarkers = [];
  City? selectedCity;
  AirQualityData? selectedCityData;
  LatLng? customMarkerLocation;
  bool isLoading = false;
  bool fetchFailed = false;
  final MapController _mapController = MapController();
  final ApiService _apiService = ApiService();
  Function? _lastFetchAction;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

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
            if (countries.isNotEmpty) {
              _fetchCitiesForCountry(countries[0].name);
            }
          });
        }
      }
    } catch (e) {
      print('Error fetching countries: $e');
    }
  }

  Future<void> _fetchCitiesForCountry(String country) async {
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
      }
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

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
            final latLng = LatLng(coords[1], coords[0]);
            markers.add(
              Marker(
                point: latLng,
                child: GestureDetector(
                  onTap: () => _fetchCityData(city),
                  child: const Icon(Icons.location_on, color: Color(0xFF609254), size: 40),
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

  Future<void> _fetchNearestCity(double lat, double lon) async {
    setState(() {
      isLoading = true;
      fetchFailed = false;
      selectedCityData = null;
      _lastFetchAction = () => _fetchNearestCity(lat, lon);
    });

    final url = Uri.parse(
        'http://api.airvisual.com/v2/nearest_city?lat=$lat&lon=$lon&key=$apiKey');
    try {
      final response = await http.get(url);
      setState(() {
        isLoading = false;
      });
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
            fetchFailed = false;
          });
        } else {
          setState(() {
            selectedCity = City(
              name: 'Unknown',
              state: 'Unknown',
              country: 'Unknown',
            );
            fetchFailed = true;
          });
        }
      } else {
        setState(() {
          selectedCity = City(
            name: 'Unknown',
            state: 'Unknown',
            country: 'Unknown',
          );
          fetchFailed = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        selectedCity = City(
          name: 'Unknown',
          state: 'Unknown',
          country: 'Unknown',
        );
        fetchFailed = true;
      });
      print('Error fetching nearest city: $e');
    }
  }

  Future<void> _fetchCityData(City city) async {
    setState(() {
      isLoading = true;
      selectedCity = city;
      selectedCityData = null;
      fetchFailed = false;
      _lastFetchAction = () => _fetchCityData(city);
    });

    final url = Uri.parse(
        'http://api.airvisual.com/v2/city?city=${city.name}&state=${city.state}&country=${city.country}&key=$apiKey');
    try {
      final response = await http.get(url);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            selectedCityData = AirQualityData.fromJson(data['data']);
            fetchFailed = false;
          });
        } else {
          setState(() {
            fetchFailed = true;
          });
        }
      } else {
        setState(() {
          fetchFailed = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        fetchFailed = true;
      });
      print('Error fetching city data: $e');
    }
  }

  Future<void> _selectCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar('Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customMarkerLocation = newLocation;
      });
      _mapController.move(newLocation, 10);
      _fetchNearestCity(position.latitude, position.longitude);
    } catch (e) {
      _showSnackbar('Error getting current location: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _suggestPlants() async {
    if (selectedCityData == null) {
      _showSnackbar('No air quality data available.');
      return;
    }

    try {
      final plants = await _apiService.getAllPlants();
      final categories = await _apiService.getAllCategories();
      final temperature = selectedCityData!.temperature;

      final categoryMap = {
        for (var category in categories) category.id: category.name.toLowerCase()
      };

      final trees = <Plant>[];
      final flowers = <Plant>[];
      final vegetables = <Plant>[];

      for (var plant in plants) {
        if (plant.temperature == 'Unknown' || plant.temperature.isEmpty) {
          continue;
        }

        try {
          String tempStr = plant.temperature.replaceAll('°C', '').trim();
          bool matchesTemperature;

          if (tempStr.contains('-')) {
            final parts = tempStr.split('-').map((s) => s.trim()).toList();
            if (parts.length != 2) continue;
            final minTemp = double.tryParse(parts[0]);
            final maxTemp = double.tryParse(parts[1]);
            if (minTemp == null || maxTemp == null) continue;
            matchesTemperature = temperature >= minTemp && temperature <= maxTemp;
          } else {
            final tempValue = double.tryParse(tempStr);
            if (tempValue == null) continue;
            matchesTemperature = temperature >= tempValue - 5 && temperature <= tempValue + 5;
          }

          if (matchesTemperature) {
            final categoryName = categoryMap[plant.categoryId]?.toLowerCase() ?? 'unknown';
            if (categoryName.contains('tree')) {
              trees.add(plant);
            } else if (categoryName.contains('flower')) {
              flowers.add(plant);
            } else if (categoryName.contains('vegetable') || categoryName.contains('veggie')) {
              vegetables.add(plant);
            }
          }
        } catch (e) {
          print('Error parsing temperature for plant ${plant.name}: $e');
          continue;
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlantSuggestionScreen(
            trees: trees,
            flowers: flowers,
            vegetables: vegetables,
          ),
        ),
      );
    } catch (e) {
      print('Error fetching plants or categories: $e');
      _showSnackbar('Error fetching plants: $e');
    }
  }

  void _retryFetch() {
    if (_lastFetchAction != null) {
      _lastFetchAction!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: customMarkerLocation ?? LatLng(31.2357, 30.0444),
              initialZoom: 5,
              onTap: (tapPosition, point) {
                setState(() => customMarkerLocation = point);
                _fetchNearestCity(point.latitude, point.longitude);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: cityMarkers),
              if (customMarkerLocation != null)
                MarkerLayer(markers: [
                  Marker(
                    point: customMarkerLocation!,
                    child: const Icon(Icons.location_on, color: Color(0xFF609254), size: 40),
                  ),
                ]),
            ],
          ),
          if (selectedCity != null)
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.6,
              builder: (BuildContext context, ScrollController scrollController) {
                return ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  child: Container(
                    color: const Color(0xfff4f5ec),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${selectedCity!.name}, ${selectedCity!.state}, ${selectedCity!.country}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff392515),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView(
                              controller: scrollController,
                              children: [
                                const SizedBox(height: 8),
                                if (isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF609254),
                                    ),
                                  )
                                else if (fetchFailed)
                                  Center(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Failed to load city data. Please try again.',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFFE31207),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: _retryFetch,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:  const Color(0xFF609254),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25.0),
                                              side: const BorderSide(color: Colors.grey, width: 1.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Try Again',
                                            style: TextStyle(
                                              color: Color(0xFFEEF0E2),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else if (selectedCityData != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'AQI: ${selectedCityData!.aqi}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff392515),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Temperature: ${selectedCityData!.temperature} °C',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff392515),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Humidity: ${selectedCityData!.humidity}%',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF392515),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Wind Speed: ${selectedCityData!.windSpeed} m/s',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF392515),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Desertification Risk: ${selectedCityData!.desertificationIndex.toStringAsFixed(1)}%',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF392515),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          height: 160,
                                          child: SfRadialGauge(
                                            axes: <RadialAxis>[
                                              RadialAxis(
                                                minimum: 0,
                                                maximum: 100,
                                                ranges: <GaugeRange>[
                                                  GaugeRange(
                                                    startValue: 0,
                                                    endValue: 30,
                                                    color: Colors.green,
                                                  ),
                                                  GaugeRange(
                                                    startValue: 30,
                                                    endValue: 60,
                                                    color: Colors.yellow,
                                                  ),
                                                  GaugeRange(
                                                    startValue: 60,
                                                    endValue: 100,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                                pointers: <GaugePointer>[
                                                  NeedlePointer(
                                                    value: selectedCityData!.desertificationIndex,
                                                    enableAnimation: true,
                                                  ),
                                                ],
                                                annotations: <GaugeAnnotation>[
                                                  GaugeAnnotation(
                                                    widget: Padding(
                                                      padding: const EdgeInsets.only(top: 50),
                                                      child: Text(
                                                        selectedCityData!.desertificationIndex < 30
                                                            ? 'Good'
                                                            : selectedCityData!.desertificationIndex <= 60
                                                            ? 'Moderate'
                                                            : 'High Risk',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    angle: 90,
                                                    positionFactor: 0.5,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 30),
                                            child: ElevatedButton(
                                              onPressed: _suggestPlants,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:  const Color(0xFF609254),
                                                foregroundColor: Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  side: const BorderSide(color: Colors.grey, width: 1.0),
                                                ),
                                              ),
                                              child: const Text(
                                                'Suggest a plant!',
                                                style: TextStyle(
                                                  color: Color(0xFFEEF0E2),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    const Text(
                                      'No data available.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectCurrentLocation,
        backgroundColor: const Color(0xFF609254),
        child: const Icon(Icons.my_location, color: Color(0xFFEEF0E2)),
      ),
    );
  }
}