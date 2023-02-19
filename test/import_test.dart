
import 'package:test/test.dart';
import 'package:todo_flutter_firebase/model/task.dart';
import 'package:todo_flutter_firebase/services/import.dart';

void main() {
  test('Import test', () {
    var input = [ "(A) Get to work @Home"];

    var expected = [ Task('Get to work', category: 'Home')];

    var output = Import.importTasks(input);
    for (var value in output) {
      print(value);
      expect(expected[0], value);
    }
  });
}