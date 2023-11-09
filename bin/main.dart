import 'package:live_json_data/abstract_json_data.dart';
import 'package:live_json_data/file_json_data.dart';
import 'package:live_json_data/http_json_data.dart';

void main() async {
  var initialData = {'someKey': 'someValue'};

  var fileJsonData = FileJsonData(
      '/Users/sjarosz/project/beatrix/live_json_data/data/data.json',
      initialData);
  fileJsonData.fetch(); // Fetches or uses initialData if provided
  print('Initial data: ${fileJsonData.data}');
/**
  // Updating an entry in 'batter'
  print('\nUpdating batter type...');
  Future<bool> updateResult =
      fileJsonData.update(['batters', 'batter', 0, 'type'], 'New Type');
  print('Batter updated: $updateResult');
  print('Data after update: ${fileJsonData.data}');
 */
  var httpJsonData =
      HttpJsonData('http://localhost:5174/data.json', initialData);
  httpJsonData.fetch(); // Fetches or uses initialData if provided

  // Access and modify data using the methods provided
  print('Initial Web data: ${httpJsonData.data}');

  // Updating an entry in 'batter'
  print('\nUpdating batter type...');
  httpJsonData.update(['batters', 'batter', 0, 'type'], 'New Type',
      (bool callback) {
    print('HERE: 000 ');

    if (callback) {
      print('Success: 000 ');
      fileJsonData.data = httpJsonData.data;
      fileJsonData.save();
      // print('Batter updated: $updateResult');
      print('Data after update: ${httpJsonData.data}');
    } else {
      print('Error: 000 ');
    }
  });

/**

  var fileJsonData = FileJsonData(
      '/Users/sjarosz/project/beatrix/live_json_data/data/data.json',
      initialData);
  //      '/Users/sjarosz/project/beatrix/live_json_data/data/new.json');
  await fileJsonData.fetch(); // Fetches or uses initialData if provided
  print('NEW data: ${fileJsonData.data}');

  var httpJsonData =
//      HttpJsonData('http://localhost:5174/data.json', initialData);
      HttpJsonData('https://httpbin.org/anything', fileJsonData.data);

  // await httpJsonData.fetch(); // Fetches or uses initialData if provided

  // Access and modify data using the methods provided
  print('HTTP data: ${httpJsonData.data}');

//////

  // Adding a new entry to the 'topping' array
  print('\nAdding a new topping...');
  var newTopping = {'id': '5008', 'type': 'Strawberry'};
  Future<bool> addResult = httpJsonData.add(['topping'], newTopping);
  print('Topping added: $addResult');
  print('Data after addition: ${httpJsonData.data}');

  // Adding a new item
  print('\nAdding a new item...');
  var newItem = {
    "userId": 1,
    "id": 14,
    "title": "new item title",
    "completed": false
  };

  // Updating an item's title
  print('\nUpdating an item title...');
  bool updateResult = await httpJsonData
      .update([1, 'title'], 'Updated Title'); // Assuming list index 1
  print('Item title updated: $updateResult');

  // Changing the 'completed' status of an item using PATCH
  print('\nUpdating the completion status of an item...');
  bool patchResult = await httpJsonData
      .update([2, 'completed'], true); // Assuming list index 2
  print('Item completion status updated: $patchResult');

  // Deleting an item
  print('\nDeleting an item...');
  bool deleteResult =
      await httpJsonData.delete([3]); // Assuming list index 3 for deletion
  print('Item deleted: $deleteResult');


   */
}
