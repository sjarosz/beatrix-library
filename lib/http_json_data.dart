import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:live_json_data/abstract_json_data.dart';

class XHttpService {
  /**void get(String url, Function callback) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        callback(true, data); // Success callback
      } else {
        callback(false,
            'Request failed with status: ${response.statusCode}.'); // Error callback
      }
    } catch (e) {
      callback(false, 'Error occurred: $e'); // Error callback
    }
  }
 */
  updateAsync(String url, List<dynamic> path, dynamic newValue,
      Function callback) async {
//      Uri.parse('$apiUrl/${pathToString(path)}'),

    try {
      var response = await http
          .put(
        Uri.parse('https://httpbin.org/anything/X}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newValue),
      )
          .then((response) {
        if (response.statusCode == 200) {
          print('HTTP Update success');
          callback(true);
        } else
          callback(false);
      });
      print(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Error occurred: $e'};
    }
  }
}

class HttpJsonData extends AbstractJsonData {
  final String apiUrl;

  HttpJsonData(this.apiUrl, [dynamic initialData]) : super(initialData);
/**
  Future<bool> updateAsync(List<dynamic> path, dynamic newValue) async {
//      Uri.parse('$apiUrl/${pathToString(path)}'),
    bool success = false;

    await http
        .put(
      Uri.parse('https://httpbin.org/anything/${pathToString(path)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newValue),
    )
        .then((response) {
      response.statusCode == 500
          ? success = true
          : success = throw ('HTTP Response code: ${response.statusCode}');
      print(response.body);
    }).catchError((error) {
      print('Error occurred: $error');
      throw ('Error occurred: $error');
    });
    return success;
  }


 */
  @override
  Future<void> fetch() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

/**  @override
  bool add(List<dynamic> path, dynamic newItem, {Function(bool)? callback}) {
    print('CURRENT: ' + data.toString());
    var response = http.post(
      Uri.parse('$apiUrl/${pathToString(path)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newItem),
    );
    print(response.body);
    return response.statusCode == 200;
  }
 */

  @override
  update(List<dynamic> path, dynamic newValue, Function(bool) callback) {
//      Uri.parse('$apiUrl/${pathToString(path)}'),

    var httpService = XHttpService();

    httpService.updateAsync(
        'https://jsonplaceholder.typicode.com/todos/1', path, newValue,
        (bool success) {
      callback(true);

      if (success) {
        print('Success! Data');
        super.update(path, newValue, (bool) {});

        callback(true);
        //  super.update(path, newValue);
      } else {
        print('Failure');
      }
    });

    return true;
  }

  @override
  Future<bool> delete(List<dynamic> path) async {
    var response = await http.delete(
      Uri.parse('$apiUrl/${pathToString(path)}'),
    );
    print(response.body);

    return response.statusCode == 200;
  }

  // PATCH method implementation
  Future<bool> patch(List<dynamic> path, dynamic newValue) async {
    var response = await http.patch(
      Uri.parse('$apiUrl/${pathToString(path)}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newValue),
    );
    print(response.body);

    return response.statusCode == 200;
  }
}
