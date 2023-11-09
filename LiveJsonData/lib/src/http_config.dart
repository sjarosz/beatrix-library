abstract class HttpConfig {
  final String baseUrl;
  final String? bearerToken;

  HttpConfig(this.baseUrl, this.bearerToken);

  Uri get uri;
  Map<String, String> get headers => {
        'Content-Type': 'application/json; charset=UTF-8',
        if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
      };
}
