// screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final bool isDarkMode = bookProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                bookProvider.toggleTheme();
              },
            ),
          ),
          ListTile(
            title: Text('Sort Books By'),
            onTap: () {
              _showSortingOptions(context);
            },
          ),
        ],
      ),
    );
  }

  void _showSortingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort Books By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Title'),
                onTap: () {
                  Provider.of<BookProvider>(context, listen: false).sortBooksBy('Title');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Author'),
                onTap: () {
                  Provider.of<BookProvider>(context, listen: false).sortBooksBy('Author');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Rating'),
                onTap: () {
                  Provider.of<BookProvider>(context, listen: false).sortBooksBy('Rating');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
