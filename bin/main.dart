//import 'package:live_json_data/abstract_json_data.dart';
import 'package:live_json_data/file_json_data.dart';
import 'package:live_json_data/http_json_data.dart';

void main() {
  var initialData = {'someKey': 'someValue'};

  var fileJsonData = FileJsonData(
      '/Users/sjarosz/project/beatrix-library/data/data.json', initialData);
  fileJsonData.fetch(); // Fetches or uses initialData if provided
  print('Initial File data: ${fileJsonData.data}');

/**
  // Updating an entry in 'batter'
  print('\nUpdating batter type1...');
  await fileJsonData
      .update(['batters', 'batter', 1, 'type'], 'OOOOO', (bool callback) {});
  fileJsonData.save();

  // Access and modify data using the methods provided
  print('Initial Web data: ${fileJsonData.data}');

  // Adding a new entry to the 'topping' array
  print('\nAdding a new topping...');
  var newTopping = {'id': '5008', 'type': 'Strawberry'};
  fileJsonData.add(['topping'], newTopping, (bool callback) {
    if (callback) {
      // fileJsonData.data = httpJsonData.data;
      fileJsonData.save();

      print('Data after update: ${fileJsonData.data}');
    } else {
      print('Error: Invalid Request for add');
    }
  });
  print('Topping added: ${fileJsonData.data}');
  print('Data after addition: ${fileJsonData.data}');
  //await fileJsonData.save();
 */

  var httpJsonData =
      HttpJsonData('http://localhost:5174/data.json', initialData);
  httpJsonData.fetch(); // Fetches or uses initialData if provided

  // Updating an entry in 'batter'
  //print('\nUpdating batter type...');
  httpJsonData.update(['batters', 'batter', 0, 'type'], 'New Type',
      (bool callback) {
    if (callback) {
      fileJsonData.data = httpJsonData.data;
      fileJsonData.save();
      print('Data after update: ${fileJsonData.data}');
    } else {
      print('Error: 000 ');
    }
  });

  // Adding a new entry to the 'topping' array
  //print('\nAdding a new topping...');
  var newTopping = {'id': '5008', 'type': 'Strawberry'};
  httpJsonData.add(['topping'], newTopping, (bool callback) {
    if (callback) {
      fileJsonData.data = httpJsonData.data;
      fileJsonData.save();

      print('Data after ADD: ${fileJsonData.data}');
    } else {
      print('Error: Invalid Request for add');
    }
  });
//  print('Topping added: ${httpJsonData.data}');
//  print('Data after addition: ${httpJsonData.data}');

  httpJsonData.delete(['topping'], newTopping, (bool callback) {
    if (callback) {
      fileJsonData.data = httpJsonData.data;
      fileJsonData.save();

      print('Data after delete: ${fileJsonData.data}');
    } else {
      print('Error: Invalid Request for DELETE');
    }
  });
//  print('Topping deleted: ${httpJsonData.data}');
//  print('Data after deletion: ${httpJsonData.data}');
}
