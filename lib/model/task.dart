import 'dart:convert';

class Task {
	String name;	// what to do
	String? description; // more detailed
	String? context;
	DateTime? deadline;

	Task(this.name, {this.description, this.context, this.deadline} );

	@override
	toString() => "Task($name)";

	static const String projectTag = '+', contextTag = '@';

	static Task fromJson(String json) {
		Map<String, dynamic> map = jsonDecode(json);
		return Task.fromMap(map);
	}

	static Task fromMap(Map m) {
		return Task(m['name'],
				description: m['description'],
			  context: m['context'],
		);
	}
}
