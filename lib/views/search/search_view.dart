import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Category 1', 'Category 2', 'Category 3'];
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                // Handle search logic here
              },
            ),
            SizedBox(height: 16.0),
            // Category Filter
            Text(
              'Filter by Category:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (isSelected) {
                        setState(() {
                          selectedCategory = isSelected ? category : 'All';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16.0),
            // Results Section
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with your dynamic data count
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Result Item ${index + 1}'),
                    subtitle: Text('Category: $selectedCategory'),
                    onTap: () {
                      // Handle item tap
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}