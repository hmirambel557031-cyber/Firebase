import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:third_flutter/crud_service.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final CrudService service = CrudService();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Firebase Lastname'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            },
          ), // IconButton
        ],
        // ⚠️ cut off here — appBar isn't closed yet in this screenshot
      ),
      // ⚠️ body: ... is missing entirely
    );
  }
}
