import 'package:flutter/material.dart';
import 'user_message.dart';

class MyAdsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See Bids'),
        backgroundColor: Color(0xFF17255A), 
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: 2,
        itemBuilder: (context, index) {
          return SellerCard();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Ads'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade300,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Karan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Icon(Icons.flag_outlined),
                Spacer(),
                Icon(Icons.thumb_up_alt_outlined),
                IconButton(
                  icon: Icon(Icons.message_rounded),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()), // Replace MessageScreen with your target screen
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Sector 80, AB Road,Delhi, India', style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            infoRow('Areas served:', 'Chandigarh & nearby areas'),
            infoRow('Job Success score:', 'At least 90%'),
            infoRow('Brand Provider:', 'Ambuja Cement'),
            infoRow('Today Price:', '1 Bag \$350/-'),
            infoRow('Delivery Provider:', '\$32/- per km'),
          ],
        ),
      ),
    );
  }

  Widget infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Text(value, style: TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  const FilterChipWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.blue.shade100,
      ),
    );
  }
}
