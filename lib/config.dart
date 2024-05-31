class Config {
  static const String fansRoute = '/fans';
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');
  static const String apiKey =
      String.fromEnvironment('API_KEY', defaultValue: 'DUMMY_API_KEY');
}
