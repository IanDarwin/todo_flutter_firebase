import 'dart:convert';

class Task {
	String? id;
	String name;	// what to do
	int? priority;	// 5 = Max, 3 = Medium, 1 = low
	String? description; // more detailed
	bool? completed = false;
	String? context;
	DateTime? deadline;

	Task(this.name, {this.id, this.description, this.priority, this.context, this.completed, this.deadline} );

	@override
	toString() {
		var ret = StringBuffer("Task($name");
		if (context != null) {
			ret.write(" @$context");
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
			"context" : context!,
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
			context: m['context'],
			priority: m['priority'] != null ? int.parse(m['priority']) : 3,
			completed: m['completed'] == 'true',
		);
	}

	@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          // id == other.id &&
          name == other.name &&
          // priority == other.priority &&
          // description == other.description &&
          // completed == other.completed &&
          context == other.context // &&
          // deadline == other.deadline
	        ;

  @override
  int get hashCode =>
      // id.hashCode ^
      name.hashCode ^
      // priority.hashCode ^
      // description.hashCode ^
      // completed.hashCode ^
      context.hashCode // ^
      // deadline.hashCode
			;
}
