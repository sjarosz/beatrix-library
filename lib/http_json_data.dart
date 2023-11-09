import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:live_json_data/abstract_json_data.dart';

class XHttpService {
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

  @override
  bool update(List<dynamic> path, dynamic newValue, Function(bool) callback) {
//      Uri.parse('$apiUrl/${pathToString(path)}'),

    var httpService = XHttpService();

    httpService.updateAsync(
        'https://jsonplaceholder.typicode.com/todos/1', path, newValue,
        (bool success) {
      if (success) {
        bool superSuccess = super.update(
            path, newValue, (bool) {}); //invoke in common update functions.
        //Affects in memory object
        callback(superSuccess);
      } else {
        print('Failure');
        callback(false);
      }
    });
    return true;
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

  @override
  Future<bool> delete(List path) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
