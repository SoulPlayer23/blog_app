import 'package:blog_app/screens/viewPost.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/screens/add_post.dart';
import 'package:blog_app/db/PostService.dart';
import 'package:blog_app/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "posts";
  List<Post> PostsList = <Post>[];

  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoved);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter post"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Visibility(
              visible: PostsList.isEmpty,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Visibility(
              visible: PostsList.isNotEmpty,
              child: Flexible(
                  child: FirebaseAnimatedList(
                      query: _database.reference().child('posts'),
                      itemBuilder: (_, DataSnapshot snap,
                          Animation<double> animation, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PostView(PostsList[index])));
                              },
                              title: Text(
                                PostsList[index].title,
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                timeago.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        PostsList[index].date)),
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                    top: 14.0, bottom: 14.0),
                                child: Text(
                                  PostsList[index].body,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        tooltip: "Add a post",
      ),
    );
  }

  _childAdded(Event event) {
    setState(() {
      PostsList.add(Post.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoved(Event event) {
    var deletedPost = PostsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });
    setState(() {
      PostsList.removeAt(PostsList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = PostsList.singleWhere((post) {
      return post.key == event.snapshot.key;
    });
    setState(() {
      PostsList[PostsList.indexOf(changedPost)] =
          Post.fromSnapshot(event.snapshot);
    });
  }
}
