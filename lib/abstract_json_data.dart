import 'dart:convert';

abstract class AbstractJsonData {
  dynamic _data;

  AbstractJsonData([dynamic initialData]) : _data = initialData;

  dynamic get data => _data; //  getter

  set data(dynamic newData) {
    // setter
    _data = newData;
  }

  Future<void> fetch();
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

  update(List<dynamic> path, dynamic newValue, Function(bool) callback) {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent[keyOrIndex] = newValue;
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent[keyOrIndex] = newValue;
      return true;
    }
    return false;
  }

  Future<bool> delete(List<dynamic> path);

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

  // Helper method to convert path to string
  String pathToString(List<dynamic> path) {
    return path.map((segment) => segment.toString()).join('/');
  }
}
