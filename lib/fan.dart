import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Fan extends StatelessWidget {
  final String id;
  final String location;

  const Fan({Key? key, required this.id, required this.location}) : super(key: key);

  Future<void> sendCommand(String command) async {
    final url = 'http://localhost:3000/fans/$id?cmd=$command';
    try {
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        // Success
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle network error
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
          ],
        ),
      ),
    );
  }
}
