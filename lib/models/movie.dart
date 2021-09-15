import 'package:intl/intl.dart';

class Movie {
  int _id;
  String _movie;
  String _director;
  String _imagePath;

  Movie(this._id, this._movie, this._director, this._imagePath);

  int get id => _id;
  String get movie => _movie;
  String get director => _director;
  String get imagePath => _imagePath;

  String get date {
    final date = DateTime.fromMillisecondsSinceEpoch(id);
    return DateFormat('EEE h:mm a, dd/MM/yyyy').format(date);
  }
}
