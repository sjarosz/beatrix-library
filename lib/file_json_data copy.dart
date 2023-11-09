import 'dart:convert';
import 'dart:io';

import 'package:live_json_data/abstract_json_data.dart';

class FileJsonData extends AbstractJsonData {
  final String filePath;
  //FileJsonData(this.filePath, [Map<String, dynamic>? initialData])

  FileJsonData(this.filePath, [dynamic initialData]) : super(initialData);

  @override
  Future<void> fetch() async {
    var file = File(filePath);
    try {
      var jsonString = await file.readAsString();
      data = jsonDecode(jsonString); // using the public setter of 'data'
    } on FileSystemException catch (e) {
      // Check if the error is due to file not found and data is not null
      if (e.osError?.errorCode == 2 && data != null) {
        // Create the file with the current data
        await file.writeAsString(
            jsonEncode(data)); // using the public getter of 'data'
      } else {
        rethrow;
      }
    }
  }

  Future<void> save() async {
    try {
      Uri uri = Uri.parse(filePath);
      if (uri.scheme.startsWith('http')) {
        // Implement the necessary logic to update the data on the server
      } else {
        final file = File(filePath);
        await file.writeAsString(jsonEncode(data));
      }
    } catch (e) {
      throw Exception('Failed to save data: $e');
    }
  }

/**  @override
  Future<bool> add(List path, Map<String, dynamic> newItem) {
    // TODO: implement add
    throw UnimplementedError();
  }
 */

  @override
  Future<bool> delete(List path) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
