import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/database_helper.dart';
import 'package:flutter_notes/models/movie.dart';
import 'package:flutter_notes/utils/constants.dart';

class MovieProvider with ChangeNotifier {
  List _items = [];

  List get items {
    return [..._items];
  }

  Movie getMovie(int id) {
    return _items.firstWhere((movie) => movie.id == id, orElse: () => null);
  }

  Future deleteMovie(int id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }

  Future addOrUpdateMovie(int id, String movie_name, String director,
      String imagePath, EditMode editMode) async {
    final movie = Movie(id, movie_name, director, imagePath);

    if (EditMode.ADD == editMode) {
      _items.insert(0, movie);
    } else {
      _items[_items.indexWhere((movie) => movie.id == id)] = movie;
    }

    notifyListeners();

    DatabaseHelper.insert({
      'id': movie.id,
      'movie': movie.movie,
      'director': movie.director,
      'imagePath': movie.imagePath,
    });
  }

  Future getMovies() async {
    final moviesList = await DatabaseHelper.getMoviesFromDB();

    _items = moviesList
        .map(
          (item) => Movie(
              item['id'], item['movie'], item['director'], item['imagePath']),
        )
        .toList();

    notifyListeners();
  }
}
