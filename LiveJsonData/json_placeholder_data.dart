import 'dart:convert';
import 'package:http/http.dart' as http;
import 'live_json_data.dart'; // Replace with the actual path to your LiveJsonData class.

class JsonPlaceholderData extends LiveJsonData {
  JsonPlaceholderData(String source) : super(source);

  /// Overrides the _addToHttp method to send a POST request to add data to a remote server.
  @override
  Future<void> _addToHttp(Uri uri, dynamic newEntry) async {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newEntry),
    );

    // Check if the server returned a successful response
    if (response.statusCode == 200 || response.statusCode == 201) {
      // You might want to update the local _data with the new entry if needed
      // This will depend on whether the server sends back the updated data or not
      // _data = jsonDecode(response.body); // Uncomment if necessary
    } else {
      throw Exception(
          'Failed to add data over HTTP. Status code: ${response.statusCode}');
    }
  }
}
