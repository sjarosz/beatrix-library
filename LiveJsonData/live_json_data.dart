import 'dart:convert'; // Import Dart's built-in JSON encoder and decoder.
import 'dart:io'; // Import Dart's IO library for file and network IO operations.
import 'package:http/http.dart'
    as http; // Import the HTTP package for making HTTP requests.

/**
 * This Dart class, LiveJsonData, provides a convenient way to handle 
 * live JSON data from both HTTP and local file sources. 
 * It supports reading, adding, updating, deleting, and saving JSON data, 
 * along with converting it to a string representation.
 */

/// A class to handle live JSON data, which can be read from a file or an HTTP source.
class LiveJsonData {
  final String _source; // The source URI as a string.
  dynamic
      _data; // The actual data read from the source, can be a Map or a List.

  /// Constructor requiring a source URI as a string.
  LiveJsonData(this._source);

  /// Asynchronously reads JSON data from the provided source.
  Future<void> read() async {
    try {
      Uri uri =
          Uri.parse(_source); // Parse the source string into a Uri object.
      if (uri.scheme.startsWith('http')) {
        // If the scheme is HTTP(S), we fetch the data from the network.
        final response = await http.get(uri); // Perform an HTTP GET request.
        if (response.statusCode == 200) {
          // If the response is OK (status code 200), decode the JSON data.
          _data = jsonDecode(response.body);
        } else {
          // If the response is not OK, throw an exception.
          throw Exception(
              'Failed to load data with status code: ${response.statusCode}');
        }
      } else {
        // If the scheme is not HTTP(S), assume it's a file path and read from the file.
        final file = File(_source);
        _data = jsonDecode(await file
            .readAsString()); // Read and decode the JSON data from the file.
      }
    } catch (e) {
      // Catch and rethrow exceptions with a more specific message.
      throw Exception('Failed to read data: $e');
    }
  }

  /// Adds a new entry to the JSON structure at the specified path.
  bool add(List<dynamic> path, dynamic newEntry) {
    dynamic parent =
        getElementAt(path); // Navigate to the parent element of the path.
    if (parent is List) {
      // If the parent element is a list, add the new entry to the list.
      parent.add(newEntry);
      return true;
    } else if (parent is Map) {
      // If the parent element is a map, merge the new entry with the map.
      if (newEntry is! Map) {
        // Ensure the new entry is also a map.
        throw Exception(
            'New entry must be a Map to add to a Map data structure');
      }
      parent.addAll(newEntry);
      return true;
    }
    return false; // If the parent element is neither a list nor a map, return false.
  }

  /// Updates the value at the specified path in the JSON structure.
  bool update(List<dynamic> path, dynamic value) {
    if (_data == null || path.isEmpty)
      return false; // If the data is null or path is empty, return false.
    dynamic parent = getElementAt(path.sublist(
        0, path.length - 1)); // Navigate to the parent element of the path.
    final keyOrIndex = path
        .last; // The last element of the path is the key or index to update.

    if (parent is Map) {
      // If the parent element is a map, update the key with the new value.
      parent[keyOrIndex] = value;
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      // If the parent element is a list, update the index with the new value.
      parent[keyOrIndex] = value;
      return true;
    }
    return false; // If the operation did not succeed, return false.
  }

  /// Deletes the value at the specified path in the JSON structure.
  bool delete(List<dynamic> path) {
    if (_data == null || path.isEmpty)
      return false; // If the data is null or path is empty, return false.
    dynamic parent = getElementAt(path.sublist(
        0, path.length - 1)); // Navigate to the parent element of the path.
    final keyOrIndex = path
        .last; // The last element of the path is the key or index to delete.

    if (parent is Map) {
      // If the parent element is a map, remove the key/value pair.
      parent.remove(keyOrIndex);
      return true;
    } else if (parent is List &&
        keyOrIndex is int &&
        keyOrIndex < parent.length) {
      // If the parent element is a list, remove the value at the index.
      parent.removeAt(keyOrIndex);
      return true;
    }
    return false; // If the operation did not succeed, return false.
  }

  /// Saves the current JSON data back to the source.
  Future<void> save() async {
    try {
      Uri uri =
          Uri.parse(_source); // Parse the source string into a Uri object.
      if (uri.scheme.startsWith('http')) {
        // If the source is an HTTP(S) URI, implement logic to save data back to the server.
        // Note: This part of the code is not implemented. You'll need to write the logic for saving data via HTTP.
      } else {
        // If the source is a file, write the JSON data back to the file.
        final file = File(_source);
        await file.writeAsString(jsonEncode(
            _data)); // Encode the data to JSON and write it to the file.
      }
    } catch (e) {
      // Catch and rethrow exceptions with a more specific message.
      throw Exception('Failed to save data: $e');
    }
  }

  /// Retrieves a value from the nested JSON structure given a path of keys/indices.
  dynamic getValue(List<dynamic> path) {
    dynamic currentData = _data; // Start with the root of the data.
    for (var key in path) {
      // Iterate through the path.
      if (currentData == null) {
        return null; // If any part of the path is not found, return null.
      } else if (currentData is Map && currentData.containsKey(key)) {
        currentData =
            currentData[key]; // If the current data is a map, access the key.
      } else if (currentData is List && currentData.asMap().containsKey(key)) {
        currentData = currentData[
            key]; // If the current data is a list, access the index.
      } else {
        // If the path is invalid, throw an exception.
        throw Exception('Invalid key or index at $key in path $path');
      }
    }
    return currentData; // Return the value at the end of the path.
  }

  /// Helper function to navigate to the element at the given path within the JSON structure.
  dynamic getElementAt(List<dynamic> path) {
    dynamic element = _data; // Start with the root of the data.
    for (var keyOrIndex in path) {
      // Iterate through the path.
      if (element is Map && element.containsKey(keyOrIndex)) {
        element = element[
            keyOrIndex]; // If the current element is a map, access the key.
      } else if (element is List &&
          keyOrIndex is int &&
          keyOrIndex < element.length) {
        element = element[
            keyOrIndex]; // If the current element is a list, access the index.
      } else {
        // If the path does not exist in the data, throw an exception.
        throw Exception('Path does not exist in the data');
      }
    }
    return element; // Return the element at the end of the path.
  }

  /// Converts the JSON data to a string with optional pretty printing.
  String toJsonString({bool pretty = false}) {
    if (_data == null)
      return 'null'; // If the data is null, return the string 'null'.

    if (pretty) {
      // If pretty printing is requested,
      var encoder = JsonEncoder.withIndent(
          '  '); // Create a JSON encoder with indentation for pretty printing.
      return encoder
          .convert(_data); // Convert the data to a pretty-printed JSON string.
    } else {
      return jsonEncode(
          _data); // Convert the data to a JSON string without pretty printing.
    }
  }

  /// Getter to expose the data.
  dynamic get data => _data;
}
