import 'dart:convert';
import 'package:http/http.dart' as http;

class LiveJsonData {
  final String apiUrl;
  Map<String, dynamic>? data;

  LiveJsonData(this.apiUrl);

  // Helper method to convert path to string
  String _pathToString(List<dynamic> path) {
    return path.map((segment) => segment.toString()).join('/');
  }

  // Fetch data from the server
  Future<void> fetch() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Add new item via POST request
  Future<bool> add(List<dynamic> path, Map<String, dynamic> newItem) async {
    var response = await http.post(
      Uri.parse('$apiUrl/${_pathToString(path)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newItem),
    );
    return response.statusCode == 200;
  }

  // Update item via PUT request
  Future<bool> update(List<dynamic> path, dynamic newValue) async {
    var response = await http.put(
      Uri.parse('$apiUrl/${_pathToString(path)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newValue),
    );
    return response.statusCode == 200;
  }

  // Update item via  PATCH request
  Future<bool> save() async {
    //TODO Make a PATCH perform wholesale replacement of existing JSON from in memory object.
    var response = await http.get(Uri.parse(apiUrl));
    return response.statusCode == 200;
  }

  // Delete item via DELETE request
  Future<bool> delete(List<dynamic> path) async {
    var response = await http.delete(
      Uri.parse('$apiUrl/${_pathToString(path)}'),
    );
    return response.statusCode == 200;
  }

  dynamic getElementAt(List<dynamic> path) {
    dynamic current = data;
    for (var key in path) {
      if (current == null) {
        break;
      }

      if (current is List && key is int) {
        // Access list element by integer index
        current = key < current.length ? current[key] : null;
      } else if (current is Map && key is String) {
        // Access map element by string key
        current = current[key];
      } else {
        // Invalid path or type
        return null;
      }
    }
    return current;
  }

  // Convert current data to JSON string
  String toJsonString({bool pretty = false}) {
    // ignore: unnecessary_null_comparison
    if (data == null) return 'null';
    return pretty
        ? JsonEncoder.withIndent('  ').convert(data)
        : jsonEncode(data);
  }
}
