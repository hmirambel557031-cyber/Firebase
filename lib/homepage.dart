import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'crud_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudService service = CrudService();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Firebase Mirambel CRUD'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        onPressed: () => openAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text('No items found', style: TextStyle(fontSize: 18)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index];
              final data = item.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    data['name']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Quantity ${data['quantity'] ?? 0}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => openEditDialog(context, item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDelete(context, item.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              service.deleteItem(id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void openAddDialog(BuildContext context) {
    nameCtrl.clear();
    qtyCtrl.clear();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save'),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final quantity = int.tryParse(qtyCtrl.text.trim());

              if (name.isNotEmpty && quantity != null) {
                service.addItem(name, quantity);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void openEditDialog(BuildContext context, DocumentSnapshot item) {
    final data = item.data() as Map<String, dynamic>;
    nameCtrl.text = data['name']?.toString() ?? '';
    qtyCtrl.text = data['quantity']?.toString() ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Update'),
            onPressed: () {
              final name = nameCtrl.text.trim();
              final quantity = int.tryParse(qtyCtrl.text.trim());

              if (name.isNotEmpty && quantity != null) {
                service.updateItem(item.id, name, quantity);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
