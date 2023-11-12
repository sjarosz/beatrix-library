import 'dart:convert';

import 'package:http/http.dart' as http;

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

  Future<Object> getAsync(String url) async {
    try {
      //url = 'https://httpbin.org/anything/X}';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(response.body);
      return jsonDecode(response.body);
    } catch (e) {
      return '{"Error occurred": "$e"}';
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
