import '../lib/live_json_data_lib.dart'; // Assume your LiveJsonData class is in this file.

void main() async {
  // Provide the path to your local test JSON file
  var jsonFile =
      '/Users/sjarosz/project/httpClientJava/dart/data.json'; // Replace with your actual file path
  var jsonDataService = LiveJsonData(jsonFile);

  // Reading the initial data
  print('Reading initial data...');
  await jsonDataService.fetch();
  print('Initial data: ${jsonDataService.data}');

  // Adding a new entry to the 'topping' array
  print('\nAdding a new topping...');
  var newTopping = {'id': '5008', 'type': 'Strawberry'};
  Future<bool> addResult = jsonDataService.add(['topping'], newTopping);
  print('Topping added: $addResult');
  print('Data after addition: ${jsonDataService.data}');

  // Updating an entry in 'batter'
  print('\nUpdating batter type...');
  Future<bool> updateResult =
      jsonDataService.update(['batters', 'batter', 0, 'type'], 'New Type');
  print('Batter updated: $updateResult');
  print('Data after update: ${jsonDataService.data}');

  // Deleting the first 'topping' entry
  print('\nDeleting a topping...');
  Future<bool> deleteResult = jsonDataService.delete(['topping', 0]);
  print('Topping deleted: $deleteResult');
  print('Data after deletion: ${jsonDataService.data}');

  // Saving the data back to the file
  print('\nSaving data back to file...');
  await jsonDataService.save();
  print('Data saved.');

  // Retrieve the type of the first batter
  var batterTypePath = ['batters', 'batter', 0, 'type'];
  var batterType = jsonDataService.getElementAt(batterTypePath);
  print('The type of the first batter is: $batterType');

  // Retrieve the toppings array
  var toppingsPath = ['topping'];
  var toppings = jsonDataService.getElementAt(toppingsPath);
  print('The toppings are: $toppings');

  // Retrieve a non-existent value, which should throw an exception
  try {
    var nonExistentValuePath = ['nonExistent', 'key'];
    var nonExistentValue = jsonDataService.getElementAt(nonExistentValuePath);
    print('Non-existent value: $nonExistentValue');
  } catch (e) {
    print(e); // Handle the error appropriately
  }

  print(jsonDataService.toJsonString(pretty: true)); // Pretty prints the JSON
  print(jsonDataService.toJsonString()); // Prints the JSON in a single line
}
