import 'package:blog_app/db/PostService.dart';
import 'package:blog_app/models/post.dart';
import 'package:blog_app/screens/home.dart';
import 'package:flutter/material.dart';

class EditPost extends StatefulWidget {
  final Post post;

  EditPost(this.post);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final GlobalKey<FormState> formKey = new GlobalKey();
  Post post = Post(0, "", "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit post"),
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
                  initialValue: widget.post.title,
                  decoration: InputDecoration(
                    labelText: "Post Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onSaved: (val) => widget.post.title = val,
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
                  initialValue: widget.post.body,
                  decoration: InputDecoration(
                    labelText: "Post Body",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onSaved: (val) => widget.post.body = val,
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
          //Navigator.pop(context);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        tooltip: "Edit post",
      ),
    );
  }

  void insertPost() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      widget.post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(widget.post.toMap());
      postService.updatePost();
    }
  }
}
