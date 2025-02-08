import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VendorActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildFilterButton(),
            SizedBox(height: 20),
            Expanded(child: _buildActivityList()),
          ],
        ),
      ),
      
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(MdiIcons.magnify),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(MdiIcons.filterVariant),
          label: Text('All'),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: index % 2 == 0 ? Icon(MdiIcons.recycle, color: Colors.green) : Icon(MdiIcons.packageVariant),
            ),
            title: Text(index % 2 == 0 ? 'Sold wood scrap' : 'Buy wood scrap'),
            subtitle: Text(index % 2 == 0 ? 'to: abcd co.' : 'from: abcd co.'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$50', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('7:26 pm', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }
}
