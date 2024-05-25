class Config {
  static const String fansRoute = '/fans';
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');
}
