import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/task.dart';

class EditPage extends StatefulWidget {
  final Task task;
  const EditPage(this.task, {super.key});

  @override
  EditPageState createState() => EditPageState();
}

final priorities = {
  "High":5,
  "Medium":3,
  "Low":1
};


var contexts = [
  "Home",
  "Work",
  "Phone",
  "Email",
  "Development",
  "Writing",
  "SysAdmin",
  'Default',
];

class EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  EditPageState();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Row(children: [
                Expanded(child:TextFormField(maxLength: 256,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.task.name,
                    autofocus: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.isEmpty ? 'Details required' : null,
                    onChanged: (s) => widget.task.name = s,
                    onSaved: (s) => widget.task.name = s!,
                    )
                ),
              ]),
              Row(children: [
                Expanded(child:TextFormField(maxLength: 1024,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Description",
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    initialValue: widget.task.description,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    //validator: (s) => s!.isEmpty ? 'Details required' : null,
                    onChanged: (s) => widget.task.description = s,
                    onSaved: (s) => widget.task.description = s,
                    ),
                ),
              ]),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Priority",
                ),
                isExpanded: true,
                items: priorities.keys.map((String prioName) {
                  return DropdownMenuItem(
                    value: priorities[prioName],
                    child: Text(prioName),
                  );
                }).toList(),
                value: widget.task.priority,
                onChanged: (value) => { widget.task.priority = value! },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Context",
                ),
                isExpanded: true,
                items: contexts.map((String cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                value: widget.task.context,
                onChanged: (value) => { widget.task.context = value },
                validator: (s) => s == null || s == 'Required' ? "Category required" : null,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                TextButton(
                    child: const Text("Cancel"),
                    onPressed: () {
                      debugPrint("'Cancel command accepted.'");
                      Navigator.pop(context, widget.task);
                    }),
                ElevatedButton(
                    child: const Text("Save/Update"),
                    onPressed: () {

                      // Make sure it has an ID!
                      widget.task.id ??= widget.task.name.hashCode.toString();

                      if (_formKey.currentState!.validate()) {
                        debugPrint("Save/Update(${widget.task})");
			                  FirebaseFirestore.instance.collection('todos')
		              	    .doc(widget.task.id)
                        .set(widget.task.toJson())
			                  .then((_) => print('Added'))
			                	.catchError((error) => print('Add failed: $error'));
                        Navigator.pop(context, widget.task);
                      } else {
                        FocusScope.of(context).requestFocus(_focusNode);
                      }
                    }),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
