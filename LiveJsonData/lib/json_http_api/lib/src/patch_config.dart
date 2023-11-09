import 'http_config.dart';

class PatchConfig extends HttpConfig {
  final int id;
  final Map<String, dynamic> body;

  PatchConfig(String baseUrl, this.id, String? bearerToken, this.body)
      : super(baseUrl, bearerToken);

  @override
  Uri get uri => Uri.parse('$baseUrl/$id');
}
