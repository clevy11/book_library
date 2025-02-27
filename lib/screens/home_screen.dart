import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import 'add_edit_book_screen.dart';
import 'book_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _profileImage;
  final picker = ImagePicker();
  String searchQuery = '';
  String sortOption = 'Title';

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final bool isDarkMode = bookProvider.isDarkMode;

    List<Book> filteredBooks = bookProvider.books
        .where((book) =>
    book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        book.author.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    filteredBooks.sort((a, b) {
      switch (sortOption) {
        case 'Author':
          return a.author.compareTo(b.author);
        case 'Rating':
          return b.rating.compareTo(a.rating);
        default:
          return a.title.compareTo(b.title);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Library',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Ensure drawer icon is white
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.black],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortingOptions(context),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search,color: Colors.white,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),

            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.black],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  _getImage(ImageSource.gallery); // Handle image picking
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage('assets/default_profile.png') as ImageProvider,
                        ),
                        const SizedBox(width: 20),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Caleb levy Buntu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Colors.amber,
                                  size: 25,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Change Profile Picture',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 20),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  bookProvider.toggleTheme();
                },
                activeColor: Colors.orange, // Thumb color when the switch is active
                activeTrackColor: Colors.yellow, // Track color when the switch is active
                inactiveThumbColor: Colors.black, // Thumb color when the switch is inactive
                inactiveTrackColor: Colors.blue, // Track color when the switch is inactive
              ),
            ),
          ],
        ),
      ),
      body: Consumer<BookProvider>(
        builder: (context, provider, child) {
          if (filteredBooks.isEmpty) {
            return const Center(child: Text('No books available. Add some books!'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                Book book = filteredBooks[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            book.author,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < book.rating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              );
                            }),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: book.isRead,
                                    onChanged: (bool? value) {
                                      Book updatedBook = Book(
                                        id: book.id,
                                        title: book.title,
                                        author: book.author,
                                        rating: book.rating,
                                        isRead: value ?? false,
                                      );
                                      provider.updateBook(updatedBook);
                                    },
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 30),
                                onPressed: () {
                                  provider.deleteBook(book.id!);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Container(
        width: 80.0,
        height: 80.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEditBookScreen()),
            );
          },
          child: const Icon(Icons.add, size: 40),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  void _showSortingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sort Books By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Title'),
                onTap: () {
                  setState(() {
                    sortOption = 'Title';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Author'),
                onTap: () {
                  setState(() {
                    sortOption = 'Author';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Rating'),
                onTap: () {
                  setState(() {
                    sortOption = 'Rating';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }
}
