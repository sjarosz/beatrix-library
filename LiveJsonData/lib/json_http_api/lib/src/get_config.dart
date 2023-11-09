import 'http_config.dart';

class GetConfig extends HttpConfig {
  GetConfig(String baseUrl, String? bearerToken) : super(baseUrl, bearerToken);

  @override
  Uri get uri => Uri.parse(baseUrl);
}
