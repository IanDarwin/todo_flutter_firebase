import 'package:flutter/material.dart';

import 'model/task.dart';

class EditPage extends StatefulWidget {
  final Task task;
  const EditPage(this.task, {super.key});

  @override
  EditPageState createState() => EditPageState();
}

var categories = [
  "Gardening",
  "Work",
  "Leisure",
  "Reading",
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
                    //focusNode: focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (s) => s!.isEmpty ? 'Details required' : null,
                    onChanged: (s) => widget.task.description = s,
                    onSaved: (s) => widget.task.description = s,
                    ),
                ),
              ]),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Category",
                ),
                // value: _selectedCategory,
                isExpanded: true,
                items: categories.map((String cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (value) => { /*XXX*/ },
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
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Save/Update(${widget.task})");
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
