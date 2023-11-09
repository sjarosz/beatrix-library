import 'package:json_http_api/json_http_api.dart';

void main() async {
  const baseUrl = 'https://jsonplaceholder.typicode.com/posts';
  const bearerToken = 'your_oauth2_token_here'; // Replace with actual token

  try {
    // Fetch
    String fetchedData = await fetch(GetConfig(baseUrl, bearerToken));
    print('Fetched items: $fetchedData');

    // Create
    String createdItem = await create(PostConfig(baseUrl, bearerToken, {
      'title': 'foo',
      'body': 'bar',
      'userId': '1',
    }));
    print('Item created: $createdItem');

    // Update
    String updatedItem = await update(PutConfig(baseUrl, 1, bearerToken, {
      'id': '1',
      'title': 'updated title',
      'body': 'updated body',
      'userId': '1',
    }));
    print('Item updated: $updatedItem');

    // Patch
    String patchedItem = await patch(PatchConfig(baseUrl, 1, bearerToken, {
      'title': 'patched title',
    }));
    print('Item patched: $patchedItem');

    // Delete
    String deletedStatus = await delete(DeleteConfig(baseUrl, 1, bearerToken));
    print('Delete status: $deletedStatus');
  } catch (e) {
    print('An error occurred: $e');
  }
}
