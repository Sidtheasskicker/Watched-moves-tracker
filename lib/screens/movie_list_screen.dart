import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/movie_provider.dart';
import 'package:flutter_notes/screens/movie_edit_screen.dart';
import 'package:flutter_notes/utils/constants.dart';
import 'package:flutter_notes/widgets/list_item.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MovieProvider>(context, listen: false).getMovies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Consumer<MovieProvider>(
                child: noMoviesUI(context),
                builder: (context, movieprovider, child) =>
                    movieprovider.items.length <= 0
                        ? child
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: movieprovider.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return header();
                              } else {
                                final i = index - 1;
                                final item = movieprovider.items[i];

                                return ListItem(
                                  item.id,
                                  item.movie,
                                  item.director,
                                  item.imagePath,
                                  item.date,
                                );
                              }
                            },
                          ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  goToMovieEditScreen(context);
                },
                child: Icon(Icons.add),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget header() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(75.0),
            bottomLeft: Radius.circular(75.0),
          ),
        ),
        height: 150.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'created by 𝔖𝔦𝔡𝔡𝔥𝔞𝔯𝔱𝔥',
              style: headerRideStyle,
            ),
            Text(
              'Watched Movies',
              style: headerMoviesStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget noMoviesUI(BuildContext context) {
    return ListView(
      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'crying_emoji.png',
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
              ),
            ),
            RichText(
              text: TextSpan(style: noMoviesStyle, children: [
                TextSpan(text: 'You did not add any Movies :( \n Tap on "'),
                TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goToMovieEditScreen(context);
                      }),
                TextSpan(text: '" to add new movie')
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void goToMovieEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(MovieEditScreen.route);
  }
}
