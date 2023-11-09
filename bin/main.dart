//import 'package:live_json_data/abstract_json_data.dart';
import 'package:live_json_data/file_json_data.dart';
import 'package:live_json_data/http_json_data.dart';

void main() async {
  var initialData = {'someKey': 'someValue'};

  var fileJsonData = FileJsonData(
      '/Users/sjarosz/project/beatrix-library/data/data.json', initialData);
  fileJsonData.fetch(); // Fetches or uses initialData if provided
  print('Initial data: ${fileJsonData.data}');

  var httpJsonData =
      HttpJsonData('http://localhost:5174/data.json', initialData);
  httpJsonData.fetch(); // Fetches or uses initialData if provided

  // Access and modify data using the methods provided
  print('Initial Web data: ${httpJsonData.data}');

  // Updating an entry in 'batter'
  print('\nUpdating batter type...');
  httpJsonData.update(['batters', 'batter', 0, 'type'], 'New Type',
      (bool callback) {
    if (callback) {
      fileJsonData.data = httpJsonData.data;
      fileJsonData.save();
      // print('Batter updated: $updateResult');
      print('Data after update: ${httpJsonData.data}');
    } else {
      print('Error: 000 ');
    }
  });
}
