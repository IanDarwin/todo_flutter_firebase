
import 'package:test/test.dart';
import 'package:todo_flutter_firebase/model/task.dart';
import 'package:todo_flutter_firebase/services/import.dart';

void main() {
  test('Import test', () {

    List<String> input = [
      "(A) Get to work @Home",
      "Bleah bleah bleah",
    ];

    var expected = [
      Task('Get to work', context: 'Home'),
      Task("Bleah bleah bleah"),
    ];

    var output = Import.importTasks(input);

    for (int i = 0; i < input.length; i++) {
      var value = output[i];
      print(value);
      expect(expected[i], value);
    }
  });
}
