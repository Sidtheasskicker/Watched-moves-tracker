import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/movie_provider.dart';
import 'package:flutter_notes/models/movie.dart';
import 'package:provider/provider.dart';

class DeletePopUp extends StatelessWidget {
  final Movie selectedMovie;

  DeletePopUp(this.selectedMovie);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete the movie?'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Provider.of<MovieProvider>(context, listen: false)
                .deleteMovie(selectedMovie.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
