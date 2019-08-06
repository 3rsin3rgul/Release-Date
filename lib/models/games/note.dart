import 'package:firebase_database/firebase_database.dart';

class Note {
  String _id;
  String _title;
  String _description;
  String _image;

  Note(this._id, this._title, this._description, this._image);

  Note.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
    this._image = obj['image'];
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;
  String get image => _image;

  Note.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _title = snapshot.value['title'];
    _description = snapshot.value['description'];
    _image = snapshot.value['image'];
  }
}
