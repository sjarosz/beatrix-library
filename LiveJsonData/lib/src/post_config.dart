import 'http_config.dart';

class PostConfig extends HttpConfig {
  final Map<String, dynamic> body;

  PostConfig(String baseUrl, String? bearerToken, this.body)
      : super(baseUrl, bearerToken);

  @override
  Uri get uri => Uri.parse(baseUrl);
}
