import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_notes/helper/movie_provider.dart';
import 'package:flutter_notes/models/movie.dart';
import 'package:flutter_notes/utils/constants.dart';
import 'package:flutter_notes/widgets/delete_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'movie_view_screen.dart';

class MovieEditScreen extends StatefulWidget {
  static const route = '/edit-movie';

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  final movieController = TextEditingController();
  final directorController = TextEditingController();

  File _image;

  final picker = ImagePicker();

  bool firstTime = true;
  Movie selectedMovie;
  int id;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (firstTime) {
      id = ModalRoute.of(this.context).settings.arguments;

      if (id != null) {
        selectedMovie = Provider.of<MovieProvider>(
          this.context,
          listen: false,
        ).getMovie(id);

        movieController.text = selectedMovie?.movie;
        directorController.text = selectedMovie?.director;

        if (selectedMovie?.imagePath != null) {
          _image = File(selectedMovie.imagePath);
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    movieController.dispose();
    directorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            color: black,
            onPressed: () {
              getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.insert_photo),
            color: black,
            onPressed: () {
              getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: black,
            onPressed: () {
              if (id != null) {
                _showDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: movieController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createMovie,
                decoration: InputDecoration(
                    hintText: 'Enter Movie Name', border: InputBorder.none),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.delete,
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: directorController,
                maxLines: null,
                style: createDirector,
                decoration: InputDecoration(
                  hintText: 'Enter Name of the directors...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (movieController.text.isEmpty)
            movieController.text = 'Untitled Movie';

          saveMovie();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');

    setState(() {
      _image = tmpFile;
    });
  }

  void saveMovie() {
    String movie = movieController.text.trim();
    String director = directorController.text.trim();

    String imagePath = _image != null ? _image.path : null;

    if (id != null) {
      Provider.of<MovieProvider>(
        this.context,
        listen: false,
      ).addOrUpdateMovie(id, movie, director, imagePath, EditMode.UPDATE);
      Navigator.of(this.context).pop();
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;

      Provider.of<MovieProvider>(this.context, listen: false)
          .addOrUpdateMovie(id, movie, director, imagePath, EditMode.ADD);

      Navigator.of(this.context)
          .pushReplacementNamed(MovieViewScreen.route, arguments: id);
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedMovie);
        });
  }
}
