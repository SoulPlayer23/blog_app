import 'package:firebase_database/firebase_database.dart';

class PostService {
  String nodeName = "posts";
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference _databaseReference;
  final Map post;

  PostService(this.post);

  addPost() {
    //give a reference to the posts node
    _databaseReference = database.reference().child(nodeName);
    //returns map and insert into the db
    _databaseReference.push().set(post);
  }
}
