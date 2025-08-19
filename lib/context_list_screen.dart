import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/Context.dart';

// The main widget to display and manage the category list.
// It requires an instance of FirebaseFirestore and the Firestore collection path.
// @author Google Gemini, prompted by Ian Darwin
//
class ContextListScreen extends StatefulWidget {
  final FirebaseFirestore firestore;
  final String collectionPath = 'contexts';

  const ContextListScreen(this.firestore, { super.key });

  @override
  _ContextListScreenState createState() => _ContextListScreenState();
}

class _ContextListScreenState extends State<ContextListScreen> {
  // A controller for the text field in dialogs.
  final TextEditingController _textEditingController = TextEditingController();

  // Displays a dialog for adding or renaming a category.
  Future<void> _showContextDialog({
    String? categoryId,
    String? initialName,
  }) async {
    // Clear the text controller before showing the dialog.
    _textEditingController.text = initialName ?? '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initialName == null ? 'Add New Context' : 'Rename Context'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(labelText: 'Context Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = _textEditingController.text.trim();
                if (newName.isNotEmpty) {
                  if (categoryId == null) {
                    _addContext(newName);
                  } else {
                    _renameContext(categoryId, newName);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(initialName == null ? 'Add' : 'Rename'),
            ),
          ],
        );
      },
    );
  }

  // Adds a new category document to Firestore.
  Future<void> _addContext(String name) async {
    try {
      await widget.firestore.collection(widget.collectionPath).add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _showErrorDialog('Failed to add category: $e');
    }
  }

  // Renames an existing category document in Firestore.
  Future<void> _renameContext(String id, String newName) async {
    try {
      await widget.firestore.collection(widget.collectionPath).doc(id).update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _showErrorDialog('Failed to rename category: $e');
    }
  }

  // Deletes a category document from Firestore.
  Future<void> _deleteContext(String id) async {
    try {
      await widget.firestore.collection(widget.collectionPath).doc(id).delete();
    } catch (e) {
      _showErrorDialog('Failed to delete category: $e');
    }
  }

  // Shows an error dialog with the given message.
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a StreamBuilder to listen for real-time updates from Firestore.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contexts'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.firestore
            .collection(widget.collectionPath)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Contexts found. Please add yours.'));
          }

          final contexts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Context(
              name: data['name'] ?? 'Untitled Context',
              id: doc.id,
            );
          }).toList();

          return ListView.builder(
            itemCount: contexts.length,
            itemBuilder: (context, index) {
              final context = contexts[index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(context.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showContextDialog(
                          categoryId: context.id.toString(),
                          initialName: context.name,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteContext(context.id.toString()),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContextDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
