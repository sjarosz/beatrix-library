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

Future<void> fetchPosts({String? bearerToken}) async {
  final response = await http.get(Uri.parse(baseUrl),
      headers: getHeaders(bearerToken: bearerToken));
  if (response.statusCode == 200) {
    List<dynamic> posts = jsonDecode(response.body);
    print('Fetched posts: $posts');
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<void> createPost({String? bearerToken}) async {
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
    print('Post created: ${response.body}');
  } else {
    throw Exception('Failed to create post');
  }
}

Future<void> updatePost(int id, {String? bearerToken}) async {
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
    print('Post updated: ${response.body}');
  } else {
    throw Exception('Failed to update post');
  }
}

Future<void> patchPost(int id, {String? bearerToken}) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/$id'),
    headers: getHeaders(bearerToken: bearerToken),
    body: jsonEncode(<String, String>{
      'title': 'patched title',
    }),
  );
  if (response.statusCode == 200) {
    print('Post patched: ${response.body}');
  } else {
    throw Exception('Failed to patch post');
  }
}

Future<void> deletePost(int id, {String? bearerToken}) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/$id'),
    headers: getHeaders(bearerToken: bearerToken),
  );
  if (response.statusCode == 200) {
    print('Post deleted');
  } else {
    throw Exception('Failed to delete post');
  }
}

void main() async {
  // You would typically pass the bearerToken from secure storage or a config
  await fetchPosts(bearerToken: bearerToken);
  await createPost(bearerToken: bearerToken);
  await updatePost(1,
      bearerToken: bearerToken); // Assuming there's a post with ID 1
  await patchPost(1,
      bearerToken: bearerToken); // Assuming there's a post with ID 1
  await deletePost(1,
      bearerToken: bearerToken); // Assuming there's a post with ID 1
}
