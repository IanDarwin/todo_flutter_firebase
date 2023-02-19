import 'dart:convert';

class Task {
	String? id;
	String name;	// what to do
	int? priority;	// 5 = Max, 3 = Medium, 1 = low
	String? description; // more detailed
	bool? completed = false;
	String? category;
	DateTime? deadline;

	Task(this.name, {this.id, this.description, this.priority, this.category, this.completed, this.deadline} );

	@override
	toString() {
		var ret = StringBuffer("Task($name");
		if (category != null) {
			ret.write(" @$category");
		}
		ret.write(")");
		return ret.toString();
	}

	static const String projectTag = '+', contextTag = '@';

	Map<String, String> toJson() {
		return {
			"id": id??"NONE",
			"name": name,
			"description": description == null ? "" : description!,
			"completed": completed == null ? "false" : (completed == true).toString(),
			"category" : category!,
			"priority" : priority!.toString(),
		};
	}

	static Task fromJson(String json) {
		Map<String, dynamic> map = jsonDecode(json);
		return Task.fromMap(map);
	}

	static Task fromMap(Map m) {
		return Task(
			m['name'],
			id: m['id'],
			description: m['description'],
			category: m['category'],
			priority: m['priority'] != null ? int.parse(m['priority']) : 3,
			completed: m['completed'] == 'true',
		);
	}

	@override
	operator==(other) {
		if (other is! Task) {
			return false;
		}
		if (name != other.name) {
			return false;
		}
		if (category == null || other.category == null || category != other.category) {
			return false;
		}
		return true;
	}
}
