// providers/book_provider.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_helper.dart';

class BookProvider extends ChangeNotifier {
  bool _isDarkMode = false; // Example variable for dark mode

  List<Book> _books = []; // List of books

  // Getter for dark mode
  bool get isDarkMode => _isDarkMode;

  // Getter for books
  List<Book> get books => _books;

  // Method to toggle theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // Method to sort books by a criteria
  void sortBooksBy(String criteria) {
    switch (criteria) {
      case 'Title':
        _books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Author':
        _books.sort((a, b) => a.author.compareTo(b.author));
        break;
      case 'Rating':
        _books.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    // Add more cases as needed
      default:
        break;
    }
    notifyListeners();
  }

  // Method to load books (you may have this already)
  Future<void> loadBooks() async {
    _books = await DatabaseHelper.instance.getBooks();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    final int id = await DatabaseHelper.instance.insertBook(book);
    final newBook = book.copyWith(id: id);
    _books.add(newBook);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book);
    final index = _books.indexWhere((b) => b.id == book.id);
    _books[index] = book;
    notifyListeners();
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}