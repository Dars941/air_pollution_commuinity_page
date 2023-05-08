import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:screens/utils/keys%20(1).dart';
//import 'package:screens/keys.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> districtNames = [
      'Alappuzha',
      'Ernakulam',
      'Idukki',
      'Kannur',
      'Kasaragod',
      'Kollam',
      'Kottayam',
      'Kozhikode',
      'Malappuram',
      'Palakkad',
      'Pathanamthitta',
      'Thiruvananthapuram',
      'Thrissur',
      'Wayanad'
    ];

    List<String> filteredDistrictNames = districtNames
        .where((element) => element
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                isDense: true,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filteredDistrictNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredDistrictNames[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WeatherDataPage(filteredDistrictNames[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDataPage extends StatelessWidget {
  const WeatherDataPage(this.district, {Key? key}) : super(key: key);

  final String district;

  Future<void> _fetchWeatherData() async {
    final url =
        "https://api.weatherbit.io/v2.0/current/airquality?key=$apiKey&city=$district";
    try {
      final res = await Dio().get(url);
      return res.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Data')),
      body: FutureBuilder(
        future: _fetchWeatherData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final data = snapshot.data;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['city_name']),
                Text('AQI: ${data['data'][0]['aqi']}'),
                Text('CO: ${data['data'][0]['co']}'),
                Text('NO2: ${data['data'][0]['no2']}'),
                Text('O3: ${data['data'][0]['o3']}'),
                Text('SO2: ${data['data'][0]['so2']}'),
                Text('PM2.5: ${data['data'][0]['pm25']}'),
                Text('PM10: ${data['data'][0]['pm10']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
