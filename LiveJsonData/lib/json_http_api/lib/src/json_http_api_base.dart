import 'dart:convert';
import 'package:http/http.dart' as http;

// Import your configurations
import 'get_config.dart';
import 'post_config.dart';
import 'put_config.dart';
import 'patch_config.dart';
import 'delete_config.dart';

Future<String> fetch(GetConfig config) async {
  final response = await http.get(config.uri, headers: config.headers);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<String> create(PostConfig config) async {
  final response = await http.post(
    config.uri,
    headers: config.headers,
    body: jsonEncode(config.body),
  );
  if (response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception('Failed to create item');
  }
}

Future<String> update(PutConfig config) async {
  final response = await http.put(
    config.uri,
    headers: config.headers,
    body: jsonEncode(config.body),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to update item');
  }
}

Future<String> patch(PatchConfig config) async {
  final response = await http.patch(
    config.uri,
    headers: config.headers,
    body: jsonEncode(config.body),
  );
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to patch item');
  }
}

Future<String> delete(DeleteConfig config) async {
  final response = await http.delete(config.uri, headers: config.headers);
  if (response.statusCode == 200) {
    return 'Item deleted';
  } else {
    throw Exception('Failed to delete item');
  }
}
