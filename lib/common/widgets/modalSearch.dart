import 'package:flutter/material.dart';

class SearchFormWidget extends StatefulWidget {
  @override
  _SearchFormWidgetState createState() => _SearchFormWidgetState();
}

class _SearchFormWidgetState extends State<SearchFormWidget> {
  TextEditingController _searchController = TextEditingController();
  bool _applyFilter = false;



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          margin: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Perform search logic here using _searchController.text, _applyFilter, etc.
                        },
                        child: const Text('Search'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Close the search form
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




