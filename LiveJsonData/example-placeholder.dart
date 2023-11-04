import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

// Example OAuth2 Bearer token
const String bearerToken =
    'your_oauth2_token_here'; // Replace with actual token

Map<String, String> getHeaders({String? bearerToken}) {
  return {
    'Content-Type': 'application/json; charset=UTF-8',
    if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
  };
}

Future<void> fetch({String? bearerToken}) async {
  final response = await http.get(Uri.parse(baseUrl),
      headers: getHeaders(bearerToken: bearerToken));
  if (response.statusCode == 200) {
    List<dynamic> items = jsonDecode(response.body);
    print('Fetched items: $items');
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<void> create({String? bearerToken}) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: getHeaders(bearerToken: bearerToken),
    body: jsonEncode(<String, String>{
      'title': 'foo',
      'body': 'bar',
      'userId': '1',
    }),
  );
  if (response.statusCode == 201) {
    print('Item created: ${response.body}');
  } else {
    throw Exception('Failed to create item');
  }
}

Future<void> update(int id, {String? bearerToken}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/$id'),
    headers: getHeaders(bearerToken: bearerToken),
    body: jsonEncode(<String, String>{
      'id': id.toString(),
      'title': 'updated title',
      'body': 'updated body',
      'userId': '1',
    }),
  );
  if (response.statusCode == 200) {
    print('Item updated: ${response.body}');
  } else {
    throw Exception('Failed to update item');
  }
}

Future<void> patch(int id, {String? bearerToken}) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/$id'),
    headers: getHeaders(bearerToken: bearerToken),
    body: jsonEncode(<String, String>{
      'title': 'patched title',
    }),
  );
  if (response.statusCode == 200) {
    print('Item patched: ${response.body}');
  } else {
    throw Exception('Failed to patch item');
  }
}

Future<void> delete(int id, {String? bearerToken}) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/$id'),
    headers: getHeaders(bearerToken: bearerToken),
  );
  if (response.statusCode == 200) {
    print('Item deleted');
  } else {
    throw Exception('Failed to delete item');
  }
}

void main() async {
  // You would typically pass the bearerToken from secure storage or a config
  await fetch(bearerToken: bearerToken);
  await create(bearerToken: bearerToken);
  await update(1,
      bearerToken: bearerToken); // Assuming there's a item with ID 1
  await patch(1, bearerToken: bearerToken); // Assuming there's a item with ID 1
  await delete(1,
      bearerToken: bearerToken); // Assuming there's a item with ID 1
}
