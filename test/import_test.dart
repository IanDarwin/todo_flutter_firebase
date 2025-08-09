
import 'package:test/test.dart';
import 'package:todo_flutter_firebase/model/task.dart';
import 'package:todo_flutter_firebase/services/import.dart';

void main() {
  test('Import test', () {

    List<String> input = [
      "(A) Get to work @Home +Bar",
      "Bleah bleah bleah",
    ];

    var expected = [
      Task('Get to work', 'Home', 'Bar'),
      Task("Bleah", "@bleah", "+bleah"),
    ];

    for (int i = 0; i < input.length; i++) {
      var value = Import.importTask(input[i]);
      print("${input[i]} => $value");
      expect(expected[i], value);
    }
  });
}
