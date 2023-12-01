import 'package:flutter/material.dart';

class ModalSearchPost extends StatefulWidget {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ModalSearchPost();
      },
    );
  }

  @override
  _ModalSearchPostState createState() => _ModalSearchPostState();
}

class _ModalSearchPostState extends State<ModalSearchPost> {
  TextEditingController _searchController = TextEditingController();
  bool _applyFilter = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              decoration: InputDecoration(labelText: 'Search'),
            ),
            CheckboxListTile(
              title: const Text('Apply Filter'),
              value: _applyFilter,
              onChanged: (value) {
                setState(() {
                  _applyFilter = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Perform search logic here using _searchController.text, _applyFilter, etc.
                Navigator.pop(context); // Close the modal
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Close the search form
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
