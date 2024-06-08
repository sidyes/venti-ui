import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:venti_ui/config.dart';

class Fan extends StatelessWidget {
  final String id;
  final String location;

  const Fan({Key? key, required this.id, required this.location})
      : super(key: key);

  Future<void> sendCommand(String command) async {
    final url = '${Config.baseUrl}${Config.fansRoute}/$id?cmd=$command';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-API-KEY': Config.apiKey,
        },
      );
      if (response.statusCode == 200) {
        // Success
      } else {
        Fluttertoast.showToast(
            msg: "Failed to send command: $command",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      // Handle network error
      Fluttertoast.showToast(
          msg: "Network error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // To handle overflow if content is too large
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
                    child: const Text('slowest'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_2'),
                    child: const Text('slower'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_3'),
                    child: const Text('normal'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_4'),
                    child: const Text('fast'),
                  ),
                  ElevatedButton(
                    onPressed: () => sendCommand('SPEED_5'),
                    child: const Text('fastest'),
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
                    const Text(
                      'Running with slow speed for five minutes every hour for 7 hours',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => sendCommand('NIGHT_MODE'),
                        child: const Text('Mode 1'),
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
