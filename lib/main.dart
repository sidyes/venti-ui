import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'config.dart';
import 'fan.dart';
import 'fancy-title.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Venti UI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyDevicesPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Device {
  final String id;
  final String location;

  Device({required this.id, required this.location});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      location: json['location'],
    );
  }
}

class MyDevicesPage extends StatefulWidget {
  const MyDevicesPage({super.key, required this.title});

  final String title;

  @override
  State<MyDevicesPage> createState() => _MyDevicesPageState();
}

class _MyDevicesPageState extends State<MyDevicesPage> {
  late Future<List<Device>> _devicesFuture;

  @override
  void initState() {
    super.initState();
    _devicesFuture = fetchDevices();
  }

  Future<List<Device>> fetchDevices() async {
    try {
      final response = await http.get(
        Uri.parse(Config.baseUrl + Config.fansRoute),
        headers: {
          'X-API-KEY': Config.apiKey,
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((device) => Device.fromJson(device)).toList();
      } else {
        Fluttertoast.showToast(
            msg: "Failed to load devices",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return [];
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00BCD4), // Light blue
                Color(0xFF00838F), // Darker blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const FancyTitle(),
      ),
      body: Center(
        child: FutureBuilder<List<Device>>(
          future: _devicesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //return Text('No Devices could be found.');

              List dummyData = [Device(id: "0", location: "Living Room")];
              return Center(
                  child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: dummyData!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Fan(
                                id: dummyData![index].id,
                                location: dummyData![index].location,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(dummyData![index].location),
                      ));
                },
              ));
            } else {
              return Center(
                  child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Fan(
                                id: snapshot.data![index].id,
                                location: snapshot.data![index].location,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text(snapshot.data![index].location),
                      ));
                },
              ));
            }
          },
        ),
      ),
    );
  }
}
