import 'package:blog_app/db/PostService.dart';
import 'package:blog_app/models/post.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> formKey = new GlobalKey();
  Post post = Post(0, "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a post"),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Post Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onSaved: (val) => post.title = val,
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Post Title can't be empty";
                    } else if (val.length > 16) {
                      return "Title can't have more than 16 characters";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Post Body",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onSaved: (val) => post.body = val,
                  // ignore: missing_return
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Post body can't be empty";
                    }
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertPost();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        tooltip: "Add a post",
      ),
    );
  }

  void insertPost() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(post.toMap());
      postService.addPost();
    }
  }
}
