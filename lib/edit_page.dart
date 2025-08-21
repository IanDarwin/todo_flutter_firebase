import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'model/Context.dart';
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


class EditPageState extends State<EditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  Context? _selectedContext;
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
                    // No validation - this one is optional,
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
                validator: (s) => s == null ? "Priority required" : null,
              ),
              const SizedBox(width: 100, height: 15),
              StreamBuilder<QuerySnapshot>(
                // The stream is created by getting a snapshot of the 'contexts' collection.
                // This will emit a new QuerySnapshot object every time the collection changes.
                stream: FirebaseFirestore.instance.collection(Constants.firebase_contexts_collectionPath).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // Check for errors
                  if (snapshot.hasError) {
                    return Text('Something went wrong: ${snapshot.error}');
                  }

                  // Show a loading indicator while waiting for data
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  // If the snapshot has data, process it and build the dropdown
                  if (snapshot.hasData) {
                    // Convert the QuerySnapshot into a list of Context objects,
                    // using .map() and Context's fromFirestore factory constructor.
                    List<Context> contexts = snapshot.data!.docs
                        .map((doc) => Context.fromFirestore(doc))
                        .toList();

                    // If the list of contexts is empty, show a message
                    if (contexts.isEmpty) {
                      return const Text('No contexts found. Go ahead and add some!');
                    }

                    // Build the DropdownButton of Contexts
                    return DropdownButtonFormField<Context>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Context",
                        ),
                      isExpanded: true,
                      // If there's no selected context, default to the first one in the list
                      // initialValue: _selectedContext ?? contexts[0],
                      initialValue: Context.byName(widget.task.context??'Default', contexts),
                      // When a new item is selected, update the state
                      onChanged: (Context? newValue) {
                        setState(() {
                          _selectedContext = newValue; // XXX Merge these?
                          widget.task.context = newValue!.name;
                        });
                      },
                      // Generate the list of items from our contexts list
                      items: contexts.map<DropdownMenuItem<Context>>((Context context) {
                        return DropdownMenuItem<Context>(
                          value: context,
                          child: Row(
                            children: [
                              if (context.icon != null) context.icon!, // Display the icon if it exists
                              if (context.icon != null) const SizedBox(width: 8),
                              Text(context.name),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                  // Fallback case (should not be reached in most scenarios)
                  return const Text('Loading...');
                },
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
			                  .then((_) => print('Saved'))
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
