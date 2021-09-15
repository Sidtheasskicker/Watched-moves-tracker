import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/movie_view_screen.dart';
import 'package:provider/provider.dart';

import 'helper/movie_provider.dart';
import 'screens/movie_edit_screen.dart';
import 'screens/movie_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: MovieProvider(),
      child: MaterialApp(
        title: "Watched Movies",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => NoteListScreen(),
          MovieViewScreen.route: (context) => MovieViewScreen(),
          MovieEditScreen.route: (context) => MovieEditScreen(),
        },
      ),
    );
  }
}
