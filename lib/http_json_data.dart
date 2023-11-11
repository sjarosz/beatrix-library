import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:live_json_data/abstract_json_data.dart';
//import 'xhttp_service.dart'; // Ensure you import the XHttpService class correctly

class XHttpService {
  Future<bool> patchAsync(String url, dynamic newValue) async {
    try {
      url = 'https://httpbin.org/anything/X}';

      var response = await http.patch(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newValue),
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> getAsync(String url) async {
    try {
      url = 'https://httpbin.org/anything/X}';

      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> postAsync(String url, dynamic newValue) async {
    try {
      url = 'https://httpbin.org/anything/X}';

      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newValue),
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> putAsync(String url, dynamic newValue) async {
    try {
      url = 'https://httpbin.org/anything/X}';

      var response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newValue),
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> deleteAsync(String url) async {
    try {
      url = 'https://httpbin.org/anything/X}';

      var response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}

class HttpJsonData extends AbstractJsonData {
  final String apiUrl;

  HttpJsonData(this.apiUrl, [dynamic initialData]) : super(initialData);

  @override
  Future<bool> update(List<dynamic> path, dynamic newValue) async {
    var httpService = XHttpService();
    bool success = await httpService.putAsync(apiUrl, newValue);
    if (success) {
      return super.update(path, newValue);
    } else {
      print('HTTP update failure');
      return false;
    }
  }

  @override
  Future<bool> add(List<dynamic> path, dynamic newEntry) async {
    var httpService = XHttpService();
    bool success = await httpService.postAsync(apiUrl, newEntry);
    if (success) {
      return super.add(path, newEntry);
    } else {
      print('HTTP add failure');
      return false;
    }
  }

  @override
  Future<bool> delete(List<dynamic> path, dynamic entryToRemove) async {
    var httpService = XHttpService();
    bool success = await httpService.deleteAsync(apiUrl);
    if (success) {
      return super.delete(path, entryToRemove);
    } else {
      print('HTTP delete failure');
      return false;
    }
  }

  @override
  Future<void> fetch() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
