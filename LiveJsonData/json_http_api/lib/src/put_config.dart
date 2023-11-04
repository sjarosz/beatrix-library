import 'http_config.dart';

class PutConfig extends HttpConfig {
  final int id;
  final Map<String, dynamic> body;

  PutConfig(String baseUrl, this.id, String? bearerToken, this.body)
      : super(baseUrl, bearerToken);

  @override
  Uri get uri => Uri.parse('$baseUrl/$id');
}
