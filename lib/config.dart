import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static final String baseUrl = dotenv.get('API_URL');
  static const String fansRoute = '/fans';
}
