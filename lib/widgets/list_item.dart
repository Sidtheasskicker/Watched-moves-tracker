import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/screens/movie_view_screen.dart';
import 'package:flutter_notes/utils/constants.dart';

class ListItem extends StatelessWidget {
  final int id;
  final String movie;
  final String director;
  final String imagePath;
  final String date;

  ListItem(this.id, this.movie, this.director, this.imagePath, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, MovieViewScreen.route, arguments: id);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: white,
            boxShadow: shadow,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: grey,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: itemMovie,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        date,
                        overflow: TextOverflow.ellipsis,
                        style: itemDateStyle,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          director,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: itemDirectorStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (imagePath != null)
                Row(
                  children: [
                    SizedBox(
                      width: 12.0,
                    ),
                    Container(
                      width: 80.0,
                      height: 95.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: FileImage(
                            File(imagePath),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
