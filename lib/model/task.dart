import 'dart:convert';

class Task {
	String? id;
	String name;	// what to do
	String? description; // more detailed
	bool? completed = false;
	String? context;
	DateTime? deadline;

	Task(this.name, {this.id, this.description, this.context, this.completed, this.deadline} );

	@override
	toString() => "Task($name)";

	static const String projectTag = '+', contextTag = '@';

	Map<String, String> toJson() {
		return {
			"id": id??"NONE",
			"name": name,
			"description": description == null ? "" : description!,
			"completed": completed == null ? "false" : (completed == true).toString(),
		};
	}

	static Task fromJson(String json) {
		Map<String, dynamic> map = jsonDecode(json);
		return Task.fromMap(map);
	}

	static Task fromMap(Map m) {
		print("Task.fromMap($m)");
		return Task(
			  m['name'],
			id: m['id'],
			description: m['description'],
			  context: m['context'],
			completed: m['completed'] == 'true',
		);
	}

}
