import 'package:flutter/material.dart';
import 'api_service.dart';
import 'jadwal_sholat.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PrayerTimesScreen(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat', // Optional: Change to a custom font
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late Future<PrayerTimes> futurePrayerTimes;
  String _selectedCity = 'Jakarta';
  String _selectedCountry = 'Indonesia';

  final List<String> cities = ['Jakarta', 'Bandung', 'Surabaya', 'Medan'];
  final List<String> countries = ['Indonesia', 'Malaysia', 'Singapore'];

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  void _fetchPrayerTimes() {
    setState(() {
      futurePrayerTimes = ApiService().getPrayerTimes(_selectedCity, _selectedCountry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Schedule', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCity,
                        items: cities.map((String city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCity = newValue!;
                            _fetchPrayerTimes();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Pilih Kota',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<PrayerTimes>(
                    future: futurePrayerTimes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final times = snapshot.data!;
                        return ListView(
                          children: [
                            _buildPrayerTimeContainer('Fajar', times.fajr, Colors.black87),
                            _buildPrayerTimeContainer('Dzuhur', times.dhuhr, Colors.black87),
                            _buildPrayerTimeContainer('Ashar', times.asr, Colors.black87),
                            _buildPrayerTimeContainer('Maghrib', times.maghrib, Colors.black87),
                            _buildPrayerTimeContainer('Isya', times.isha, Colors.black87),
                          ],
                        );
                      } else {
                        return Center(child: Text('No data'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeContainer(String title, String time, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            time,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
