class Config {
  static const String fansRoute = '/fans';
  static String baseUrl =
      const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');

  static void setBaseUrl(String ip) {
    baseUrl = 'http://$ip';
  }

  static const String apiKey =
      String.fromEnvironment('API_KEY', defaultValue: 'DUMMY_API_KEY');
}
