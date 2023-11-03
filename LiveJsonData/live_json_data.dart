import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// A class that manages reading and writing JSON data from either a local file
/// or a remote HTTP source.
class LiveJsonData {
  // Private variable to store the source URI as a string.
  final String _source;

  // Variable to hold the data in memory after it's read from the source.
  dynamic _data;

  // Constructor that initializes the class with a given source URI.
  LiveJsonData(this._source);

  /// Public method to read data from the initialized source.
  /// It determines the source type (HTTP or file) and calls the appropriate read method.
  Future<void> read() async {
    Uri uri = Uri.parse(_source);
    if (uri.scheme.startsWith('http')) {
      await _readFromHttp(uri);
    } else {
      await _readFromFile(uri);
    }
  }

  /// Reads data from an HTTP source and decodes the JSON response.
  Future<void> _readFromHttp(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      _data = jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  }

  /// Reads data from a file and decodes the JSON content.
  Future<void> _readFromFile(Uri uri) async {
    final file = File(uri.toFilePath());
    _data = jsonDecode(await file.readAsString());
  }

  /// Public method to save data to the initialized source.
  /// It determines the source type (HTTP or file) and calls the appropriate save method.
  Future<void> save() async {
    Uri uri = Uri.parse(_source);
    if (uri.scheme.startsWith('http')) {
      await _saveToHttp(uri);
    } else {
      await _saveToFile(uri);
    }
  }

  /// Placeholder for saving data to an HTTP source.
  /// The actual implementation depends on the specific backend API used.
  Future<void> _saveToHttp(Uri uri) async {
    throw UnimplementedError('Saving to HTTP sources is not implemented.');
  }

  /// Saves the in-memory data back to a file in JSON format.
  Future<void> _saveToFile(Uri uri) async {
    final file = File(uri.toFilePath());
    await file.writeAsString(jsonEncode(_data));
  }

  /// Public method to add a new entry to the JSON data at the specified path.
  Future<bool> add(List<dynamic> path, dynamic newEntry) async {
    Uri uri = Uri.parse(_source);
    return uri.scheme.startsWith('http')
        ? await _addToHttp(uri, path, newEntry)
        : await _addToFile(path, newEntry);
  }

  /// Placeholder for adding a new entry to an HTTP source.
  Future<bool> _addToHttp(Uri uri, List<dynamic> path, dynamic newEntry) async {
    throw UnimplementedError('Adding to HTTP sources is not implemented.');
  }

  /// Adds a new entry to the data in memory and saves the updated data to a file.
  Future<bool> _addToFile(List<dynamic> path, dynamic newEntry) async {
    dynamic parent = getElementAt(path);
    if (parent is List) {
      parent.add(newEntry);
      await _saveToFile(Uri.file(_source));
      return true;
    } else if (parent is Map) {
      if (newEntry is! Map) {
        throw Exception(
            'New entry must be a Map to add to a Map data structure');
      }
      parent.addAll(newEntry);
      await _saveToFile(Uri.file(_source));
      return true;
    }
    return false;
  }

  /// Public method to update an existing entry in the JSON data at the specified path.
  Future<bool> update(List<dynamic> path, dynamic value) async {
    Uri uri = Uri.parse(_source);
    return uri.scheme.startsWith('http')
        ? await _updateToHttp(uri, path, value)
        : await _updateToFile(path, value);
  }

  /// Placeholder for updating an existing entry in an HTTP source.
  Future<bool> _updateToHttp(Uri uri, List<dynamic> path, dynamic value) async {
    throw UnimplementedError('Updating to HTTP sources is not implemented.');
  }

  /// Updates the value at the specified path in the data in memory and saves the updated data to a file.
  Future<bool> _updateToFile(List<dynamic> path, dynamic value) async {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent[keyOrIndex] = value;
      await _saveToFile(Uri.file(_source));
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent[keyOrIndex] = value;
      await _saveToFile(Uri.file(_source));
      return true;
    }
    return false;
  }

  /// Public method to delete an entry from the JSON data at the specified path.
  Future<bool> delete(List<dynamic> path) async {
    Uri uri = Uri.parse(_source);
    return uri.scheme.startsWith('http')
        ? await _deleteFromHttp(uri, path)
        : await _deleteFromFile(path);
  }

  /// Placeholder for deleting an entry from an HTTP source.
  Future<bool> _deleteFromHttp(Uri uri, List<dynamic> path) async {
    throw UnimplementedError('Deleting from HTTP sources is not implemented.');
  }

  /// Deletes the entry at the specified path in the data in memory and saves the updated data to a file.
  Future<bool> _deleteFromFile(List<dynamic> path) async {
    if (_data == null || path.isEmpty) return false;
    dynamic parent = getElementAt(path.sublist(0, path.length - 1));
    final keyOrIndex = path.last;
    if (parent is Map) {
      parent.remove(keyOrIndex);
      await _saveToFile(Uri.file(_source));
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      parent.removeAt(keyOrIndex);
      await _saveToFile(Uri.file(_source));
      return true;
    }
    return false;
  }

  /// Retrieves a value from the nested JSON structure given a path of keys/indices.
  dynamic getValue(List<dynamic> path) {
    return getElementAt(path);
  }

  /// Helper function to navigate to the element at the given path within the JSON structure.
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

  /// Converts the JSON data to a string with optional pretty print formatting.
  String toJsonString({bool pretty = false}) {
    if (_data == null) return 'null';
    if (pretty) {
      var encoder = JsonEncoder.withIndent(
          '  '); // Two-space indentation for pretty print
      return encoder.convert(_data);
    } else {
      return jsonEncode(_data);
    }
  }

  /// Getter to expose the raw data.
  dynamic get data => _data;
}
