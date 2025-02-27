import 'package:flutter/material.dart';
import 'add_edit_book_screen.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  static const routeName = '/book-detail';
  final Book book;

  BookDetailScreen({required this.book});

  Widget _buildRatingStars(double rating) {
    int fullStars = rating.toInt();
    bool hasHalfStar = rating - fullStars >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return Icon(Icons.star, color: Colors.amber, size: 30);
        } else if (index == fullStars && hasHalfStar) {
          return Icon(Icons.star_half, color: Colors.amber, size: 30);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: 30);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditBookScreen(book: book)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text('Title', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(book.title, style: TextStyle(fontSize: 16)),
              ),
            ),

            // Author
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text('Author', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(book.author, style: TextStyle(fontSize: 16)),
              ),
            ),

            // Rating
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text('Rating', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: _buildRatingStars(book.rating),
              ),
            ),

            // Read Status
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(16.0),
                title: Text('Read', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(book.isRead ? 'Yes' : 'No', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
