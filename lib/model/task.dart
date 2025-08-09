import 'dart:convert';

enum Status {
	NEW,
	ACTIVE,
	DEFERRED,
	COMPLETE;
}
const Status DEFAULT_STATUS = Status.NEW;

class Task {
	String? id;
	int? priority;	// 5 = Max, 3 = Medium, 1 = low
	bool? completed = false;

	String name;    // what to do
	String? description; // more detailed

	// Date fields:
	DateTime creationDate = DateTime.now(); // when you decided you had to do it
	DateTime? completedDate; // when you actually did it
	DateTime? dueDate;      // when to do it by
	DateTime? modified; // tstamp (UTC!); should be LocalDateTime

	// Status Fields
	String project;    // what this task is part of
	String context;    // where to do it
	Status status = DEFAULT_STATUS;

	Task(this.name, this.context, this.project, {this.id, this.description, this.priority,
		this.completed, this.dueDate} );

	@override
	toString() {
		var ret = StringBuffer("Task($name")..write(" @$context")..write(")");
		return ret.toString();
	}

	static const String projectTag = '+', contextTag = '@';

	Map<String, String> toJson() {
		return {
			"id": id??"NONE",
			"name": name,
			"description": description == null ? "" : description!,
			"completed": completed == null ? "false" : (completed == true).toString(),
			"context" : context??'Default',
			"priority" : priority!.toString(),
		};
	}

	static Task fromJson(String json) {
		Map<String, dynamic> map = jsonDecode(json);
		return Task.fromMap(map);
	}

	static Task fromMap(Map m) {
		return Task(
			m['name'], m['context'], m['project]'],
			id: m['id'],
			description: m['description'],
			priority: m['priority'] != null ? int.parse(m['priority']) : 3,
			completed: m['completed'] == 'true',
		);
	}

	static final prioLetters = ['A',null,'C',null,'E'];

	/// toTodoString converts to String but in todo.txt format!
	/// A fully-fleshed-out example from todotxt.com:
	/// x 2011-03-02 2011-03-01 Review Tim's pull request +TodoTxtTouch @github
	/// See https://github.com/todotxt/todo.txt
	/// @return the Task as a String in todo.txt format
	String toTodoString() {
		StringBuffer sb = new StringBuffer();
		if (status == Status.COMPLETE) {
			sb.write('x');
			if (completedDate != null) {
				sb..write(' ')..write(completedDate)..write(' ');
			}
		}
		if (priority != null) {
			sb..write('(')..write(prioLetters[priority!])..write(')')..write(' ');
		}
		sb..write(creationDate)..write(' ')..write(name);
		sb..write(' ')..write(projectTag)..write(project);
		sb..write(' ')..write(contextTag)..write(context);

		return sb.toString();
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
