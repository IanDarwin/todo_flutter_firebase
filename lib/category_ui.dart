import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// A simple model class for a Category, assuming each document has a 'name' field.
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}

// The main widget to display and manage the category list.
// It requires an instance of FirebaseFirestore and the Firestore collection path.
class CategoryListScreen extends StatefulWidget {
  final FirebaseFirestore firestore;
  final String collectionPath;

  const CategoryListScreen({
    Key? key,
    required this.firestore,
    this.collectionPath = 'categories', // Default to 'categories' collection
  }) : super(key: key);

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  // A controller for the text field in dialogs.
  final TextEditingController _textEditingController = TextEditingController();

  // Displays a dialog for adding or renaming a category.
  Future<void> _showCategoryDialog({
    String? categoryId,
    String? initialName,
  }) async {
    // Clear the text controller before showing the dialog.
    _textEditingController.text = initialName ?? '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initialName == null ? 'Add New Category' : 'Rename Category'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(labelText: 'Category Name'),
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
                    _addCategory(newName);
                  } else {
                    _renameCategory(categoryId, newName);
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
  Future<void> _addCategory(String name) async {
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
  Future<void> _renameCategory(String id, String newName) async {
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
  Future<void> _deleteCategory(String id) async {
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
        title: const Text('Categories'),
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
            return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Category(
              id: doc.id,
              name: data['name'] ?? 'Untitled Category',
            );
          }).toList();

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 2.0,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showCategoryDialog(
                          categoryId: category.id,
                          initialName: category.name,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCategory(category.id),
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
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
