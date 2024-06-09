import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:venti_ui/config.dart';

class Fan extends StatefulWidget {
  final String id;
  final String location;

  const Fan({Key? key, required this.id, required this.location})
      : super(key: key);

  @override
  _FanState createState() => _FanState();
}

class _FanState extends State<Fan> {
  bool isNightModeActive = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to check the status every 10 seconds
    checkStatus();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => checkStatus());
  }

  @override
  void dispose() {
    // Dispose the timer
    _timer.cancel();
    super.dispose();
  }

  Future<void> checkStatus() async {
    try {
      final statusUrl =
          '${Config.baseUrl}${Config.fansRoute}/${widget.id}/status';
      final response = await http.get(
        Uri.parse(statusUrl),
        headers: {'X-API-KEY': Config.apiKey},
      );
      if (response.statusCode == 200) {
        final isRunning = json.decode(response.body)['isRunning'];
        setState(() {
          isNightModeActive = isRunning;
        });
      } else {
        setState(() {
          isNightModeActive = false;
        });
      }
    } catch (e) {
      setState(() {
        isNightModeActive = false;
      });
    }
  }

  Future<void> sendCommand(String command) async {
    final url =
        '${Config.baseUrl}${Config.fansRoute}/${widget.id}?cmd=$command';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'X-API-KEY': Config.apiKey},
      );
      if (response.statusCode == 200) {
        // Success
        checkStatus(); // Check status after command sent
      } else {
        Fluttertoast.showToast(
          msg: "Failed to send command: $command",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Network error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => sendCommand('ON_OFF'),
                      child: const Text('ON / OFF'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => sendCommand('FRONT_REAR'),
                      child: const Text('Front / Rear'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Fan Speed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_1'),
                    child: const Text('1'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_2'),
                    child: const Text('2'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_3'),
                    child: const Text('3'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_4'),
                    child: const Text('4'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_5'),
                    child: const Text('5'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Timer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => sendCommand('TIMER_1H'),
                    child: const Text('1 hour'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('TIMER_4H'),
                    child: const Text('4 hours'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('TIMER_8H'),
                    child: const Text('8 hours'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey[900],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.nightlight_round, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Night Modes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isNightModeActive
                          ? 'Night Mode active'
                          : 'Night Mode inactive',
                      style: TextStyle(
                        color: isNightModeActive ?  Colors.lightBlue : Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode 1:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Running with slow speed for 10 minutes every hour for 7 hours',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => sendCommand('NIGHT_MODE_1'),
                        child: const Text('Start Night Mode 1'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode 2:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Running with slow speed for 30 minutes, then stops. Starts running again at 5:30 a.m.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => sendCommand('NIGHT_MODE_2'),
                        child: const Text('Start Night Mode 2'),
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
  }
}
