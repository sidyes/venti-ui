import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'config.dart';
import 'fan.dart';
import 'fancy-title.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    // Resolve the IP address
    await resolveIpAddress('_http._tcp', Config.baseUrl);
  }

  runApp(const MyApp());
}

resolveIpAddress(String service, String host) async {
  final MDnsClient client = MDnsClient();
  await client.start();

  await for (final SrvResourceRecord srv
      in client.lookup<SrvResourceRecord>(ResourceRecordQuery.service(host))) {
    print('SRV target: ${srv.target} port: ${srv.port}');

    await for (final IPAddressResourceRecord ip
        in client.lookup<IPAddressResourceRecord>(
            ResourceRecordQuery.addressIPv4(srv.target))) {
      print('IP: ${ip.address.toString()}');
      Config.setBaseUrl('http:${ip.address.toString()}');
    }
  }
  client.stop();
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
  final int id;
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
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'My Locations',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  // List of locations
                  child: FutureBuilder<List<Device>>(
                    future: _devicesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No Devices could be found.');
                      } else {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Fan(
                                        id: snapshot.data![index].id.toString(),
                                        location:
                                            snapshot.data![index].location,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: Text(snapshot.data![index].location),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
