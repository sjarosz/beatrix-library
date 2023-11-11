import 'package:live_json_data/file_json_data.dart';
import 'package:live_json_data/http_json_data.dart';

void main() async {
  var initialData = {'someKey': 'someValue'};

  var fileJsonData = FileJsonData(
      '/Users/sjarosz/project/beatrix-library/data/data.json', initialData);
  await fileJsonData.fetch();
  print('Initial File data: ${fileJsonData.data}');

  var httpJsonData =
      HttpJsonData('http://localhost:5174/data.json', initialData);
  await httpJsonData.fetch();
  print('Initial Web data: ${httpJsonData.data}');

  // Updating an entry in 'batter'
  bool updateSuccess =
      await httpJsonData.update(['batters', 'batter', 0, 'type'], 'New Type');
  if (updateSuccess) {
    fileJsonData.data = httpJsonData.data;
    await fileJsonData.save();
    print('Data after update: ${fileJsonData.data}');

    // Adding a new entry to the 'topping' array
    var newTopping = {'id': '5008', 'type': 'Strawberry'};
    bool addSuccess = await httpJsonData.add(['topping'], newTopping);
    if (addSuccess) {
      fileJsonData.data = httpJsonData.data;
      await fileJsonData.save();
      print('Data after ADD: ${fileJsonData.data}');

      // Deleting the recently added topping
      bool deleteSuccess = await httpJsonData.delete(['topping'], newTopping);
      if (deleteSuccess) {
        fileJsonData.data = httpJsonData.data;
        await fileJsonData.save();
        print('Data after delete: ${fileJsonData.data}');
      } else {
        print('Error: Invalid Request for DELETE');
      }
    } else {
      print('Error: Invalid Request for add');
    }
  } else {
    print('Error: Update failed');
  }
}
