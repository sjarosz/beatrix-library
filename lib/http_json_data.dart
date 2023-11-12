import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:live_json_data/abstract_json_data.dart';
import 'xhttp_service.dart'; // Ensure you import the XHttpService class correctly

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
    var httpService = XHttpService();
    var json = await httpService.getAsync(apiUrl);
    super.data = json;
  }
}
