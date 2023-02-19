
import '../model/task.dart';

/// Code to import plain-text ToDo files into our Todo model.
class Import {

	// XXX This isn't picking up the @Context or +Project
	static final regex =
	  RegExp(r'(x\s*)?(\([A-Z]\)\s*)?(\d{4}-\d{2}-\d{2}\s*){0,2}(.*)');

			static final int GROUP_COMPLETED = 1;
			static final int GROUP_PRIO = 2;
	static final int GROUP_1OR2_DATES = 3;
	static final int GROUP_REST = 4;

	static List<Task> importTasks(List<String> input) {
		List<Task> list = [];
		for (String s in input) {
			list.add(importTask(s));
		}
		return list;
	}
	
	static Task importTask(String str) {
		RegExpMatch? m = regex.firstMatch(str);
		Task t = Task("");
		if (m != null) {
			String? completed = m.group(GROUP_COMPLETED);
			if (completed != null && completed.startsWith("x")) {
				// t.complete();
			}
			String? prio = m.group(GROUP_PRIO);
			if (prio != null) {
				if (prio.startsWith("(")) {
					switch (prio[1]) {
						case 'A':
							t.priority = 5;
							break;
						case 'C':
							t.priority = 3;
							;
							break;
						case "E":
							t.priority = 1;
							break;
						default:
							throw new Exception("Unknown Priot");
					}
				} else { // Keyword given?
					t.priority = 3;
				}
			}
			String? dates = m![GROUP_1OR2_DATES];
			// XXX Must handle 2 dates
			if (dates != null) {
				DateTime localDate = DateTime.parse(dates);
				// ;
			}
			String? rest = m![GROUP_REST];
			StringBuffer nameSB = new StringBuffer(),
					projectSB = new StringBuffer(),
					contextSB = new StringBuffer();
			for (int i = 0; i < rest!.length; i++) {
				var ch = rest[i];
				if (ch == '+') {
					do {
						projectSB.write(rest[++i]);
					} while (i + 1 < rest!.length && ' ' != rest[i + 1]);
				} else if (ch == '@') {
					do {
						contextSB.write(rest[++i]);
					} while (i + 1 < rest.length && ' ' != rest[i + 1]);
				} else {
					nameSB.write(ch);
				}
			}
			t.name = nameSB.toString().trimRight();
			if (projectSB.length > 0) {
				var project = projectSB.toString();
			}
			if (contextSB.length > 0) {
				t.context = contextSB.toString();
			}
			return t;
		} else {
			throw Exception("Task failed to parse: $str");
		}
	}
}
