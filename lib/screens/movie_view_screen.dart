import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/movie_provider.dart';
import 'package:flutter_notes/models/movie.dart';
import 'package:flutter_notes/utils/constants.dart';
import 'package:flutter_notes/widgets/delete_popup.dart';
import 'package:provider/provider.dart';

import 'movie_edit_screen.dart';

class MovieViewScreen extends StatefulWidget {
  static const route = '/note-movie';

  @override
  _MovieViewScreenState createState() => _MovieViewScreenState();
}

class _MovieViewScreenState extends State<MovieViewScreen> {
  Movie selectedMovie;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final id = ModalRoute.of(context).settings.arguments;

    final provider = Provider.of<MovieProvider>(context);

    if (provider.getMovie(id) != null) {
      selectedMovie = provider.getMovie(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: black,
            ),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedMovie?.movie,
                style: viewMovieStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 18,
                  ),
                ),
                Text('${selectedMovie?.date}')
              ],
            ),
            if (selectedMovie.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.file(
                  File(selectedMovie.imagePath),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedMovie.director,
                style: viewDirectorStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MovieEditScreen.route,
              arguments: selectedMovie.id);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedMovie);
        });
  }
}
