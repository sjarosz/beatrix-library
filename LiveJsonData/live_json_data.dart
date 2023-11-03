import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class LiveJsonData {
  final String _source;
  dynamic _data;

  LiveJsonData(this._source);

  Future<void> read() async {
    try {
      Uri uri = Uri.parse(_source);
      if (uri.scheme.startsWith('http')) {
        final response = await http.get(uri);
        if (response.statusCode == 200) {
          _data = jsonDecode(response.body);
        } else {
          throw Exception(
              'Failed to load data with status code: ${response.statusCode}');
        }
      } else {
        final file = File(_source);
        _data = jsonDecode(await file.readAsString());
      }
    } catch (e) {
      throw Exception('Failed to read data: $e');
    }
  }

  // This method allows adding to both Lists and Maps within the nested structure
  bool add(List<dynamic> path, dynamic newEntry) {
    dynamic parent = getElementAt(path);
    if (parent is List) {
      parent.add(newEntry);
      return true;
    } else if (parent is Map) {
      if (newEntry is! Map) {
        throw Exception(
            'New entry must be a Map to add to a Map data structure');
      }
      parent.addAll(newEntry);
      return true;
    }
    return false;
  }

  bool update(List<dynamic> path, dynamic value) {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent[keyOrIndex] = value;
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent[keyOrIndex] = value;
      return true;
    }
    return false;
  }

  bool delete(List<dynamic> path) {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent.remove(keyOrIndex);
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent.removeAt(keyOrIndex);
      return true;
    }
    return false;
  }

  Future<void> save() async {
    try {
      Uri uri = Uri.parse(_source);
      if (uri.scheme.startsWith('http')) {
        // Implement the necessary logic to update the data on the server
      } else {
        final file = File(_source);
        await file.writeAsString(jsonEncode(_data));
      }
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }

  /// Retrieves a value from the nested JSON structure given a path of keys/indices.
  ///
  /// The [path] is a list of strings or integers representing keys or indices in the JSON data.
  dynamic getValue(List<dynamic> path) {
    dynamic currentData = _data;
    for (var key in path) {
      if (currentData == null) {
        return null;
      } else if (currentData is Map && currentData.containsKey(key)) {
        currentData = currentData[key];
      } else if (currentData is List && currentData.asMap().containsKey(key)) {
        currentData = currentData[key];
      } else {
        throw Exception('Invalid key or index at $key in path $path');
      }
    }
    return currentData;
  }

  // Helper function to navigate to the element at the given path within the JSON structure
  dynamic getElementAt(List<dynamic> path) {
    dynamic element = _data;
    for (var keyOrIndex in path) {
      if (element is Map && element.containsKey(keyOrIndex)) {
        element = element[keyOrIndex];
      } else if (element is List &&
          keyOrIndex is int &&
          keyOrIndex < element.length) {
        element = element[keyOrIndex];
      } else {
        throw Exception('Path does not exist in the data');
      }
    }
    return element;
  }

  String toJsonString({bool pretty = false}) {
    if (_data == null) return 'null';

    if (pretty) {
      var encoder = JsonEncoder.withIndent(
          '  '); // two space indentation for pretty print
      return encoder.convert(_data);
    } else {
      return jsonEncode(_data);
    }
  }

  dynamic get data => _data;
}

