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

  Future<bool> add(List<dynamic> path, dynamic newEntry) async {
    dynamic parent = getElementAt(path);
    if (parent is List) {
      parent.add(newEntry);
      // callback(true);

      return true;
    } else if (parent is Map) {
      if (newEntry is! Map) {
        // callback(false);

        throw Exception(
            'New entry must be a Map to add to a Map data structure');
      }
      parent.addAll(newEntry);
      // callback(true);
      return true;
    }
    // callback(false);
    return false;
  }

  Future<bool> update(List<dynamic> path, dynamic newValue) async {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent[keyOrIndex] = newValue;
      // callback(true);

      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent[keyOrIndex] = newValue;
      // callback(true);

      return true;
    }
    //  callback(false);

    return false;
  }

  Future<bool> delete(List<dynamic> path, dynamic entryToRemove) async {
    dynamic parent = getElementAt(path);

    if (parent is List) {
      // In a List, remove the last element added (assuming 'add' appends to the end).
      if (parent.isNotEmpty && parent.last == entryToRemove) {
        parent.removeLast();
        // callback(true);
        return true;
      }
    } else if (parent is Map) {
      // In a Map, remove the entry by its key.
      if (entryToRemove is Map) {
        for (var key in entryToRemove.keys) {
          if (parent.containsKey(key)) {
            parent.remove(key);
          }
        }
        //   callback(true);
        return true;
      }
    }

    // callback(false);
    return false;
  }

  dynamic getValue(List<dynamic> path) {
    /// Retrieves a value from the nested JSON structure given a path of keys/indices.
    ///
    /// The [path] is a list of strings or integers representing keys or indices in the JSON data.
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
