import 'http_config.dart';

class DeleteConfig extends HttpConfig {
  final int id;

  DeleteConfig(String baseUrl, this.id, String? bearerToken)
      : super(baseUrl, bearerToken);

  @override
  Uri get uri => Uri.parse('$baseUrl/$id');
}
