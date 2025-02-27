import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'models/book.dart';
import 'providers/book_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_book_screen.dart';
import 'screens/book_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // Request permissions first
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider()..loadBooks(),
      child: BookLibraryApp(),
    ),
  );
}

Future<void> requestPermissions() async {
  final PermissionStatus status = await Permission.contacts.request();
  if (status.isDenied) {
    print('Permission denied');
  } else if (status.isPermanentlyDenied) {
    print('Permission permanently denied');
    openAppSettings();
  } else if (status.isGranted) {
    print('Permission granted');
  }

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
  ].request();
  statuses.forEach((permission, status) {
    if (!status.isGranted) {
      print('Permission ${permission.toString()} denied');
    }
  });
}

class BookLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          return MaterialApp(
            title: 'Book Library App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
              scaffoldBackgroundColor: Colors.lightBlue[50],
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.purpleAccent),
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                iconTheme: IconThemeData(color: Colors.white), // Ensure drawer icon is white
              ),
              brightness: Brightness.dark,
            ),
            themeMode: bookProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: HomeScreen(),
            routes: {
              AddEditBookScreen.routeName: (context) => AddEditBookScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == BookDetailScreen.routeName) {
                final book = settings.arguments as Book;
                return MaterialPageRoute(
                  builder: (context) {
                    return BookDetailScreen(book: book);
                  },
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
