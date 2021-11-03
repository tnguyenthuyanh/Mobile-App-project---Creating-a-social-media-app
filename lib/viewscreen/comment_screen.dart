import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class CommentScreen extends StatefulWidget {
  static const routeName = '/commentScreen';
  final User user;
  final List<Comment> commentList;
  final PhotoMemo photoMemo;

  CommentScreen({
    required this.user,
    required this.commentList,
    required this.photoMemo,
  });

  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<CommentScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Form(
        key: formKey,
        child: con.commentList.isEmpty
            ? Text(
                'No Comment Yet',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: TextFormField(
                      controller: textController,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        filled: true,
                        fillColor: Colors.white12,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.greenAccent),
                        ),
                      ),
                      autocorrect: false,
                      onSaved: con.saveComment,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      validator: Comment.validateComment,
                      enabled: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        onPressed: con.post,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.withOpacity(0.3)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.lightBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.blue, width: 2.5),
                            ),
                          ),
                        ),
                        child: Text('Post'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: con.commentList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Colors.green[200]!.withOpacity(0.4),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    initialValue: con.commentList[index].content,
                                    autocorrect: false,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 4,
                                    enabled: false,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${con.commentList[index].commentedBy}',
                                      style:
                                          TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Controller {
  late _CommentState state;
  late List<Comment> commentList;
  late PhotoMemo photoMemo;
  late Comment comment = Comment();

  _Controller(this.state) {
    commentList = state.widget.commentList;
    photoMemo = state.widget.photoMemo;
  }

  void post() async {
      print('object');

    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
      print('object1');

    try {
      comment.commentedBy = state.widget.user.email!;
      comment.uid = state.widget.user.uid;
      comment.photoId = photoMemo.docId!;
      comment.timestamp = DateTime.now();
      String docId = await FirestoreController.addComment(comment: comment);
      comment.docId = docId;
      //state.widget.photoMemoList.insert(0, tempMemo);
      state.textController.clear();
      state.render(() {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== add comment error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Add Comment error: $e',
      );
    }
  }

  void saveComment(String? value) {
    if (value != null) comment.content = value;
  }

  // void delete() async {
  //   MyDialog.circularProgressStart(state.context);
  //   delIndexes.sort(); // ascending order
  //   for (int i = delIndexes.length - 1; i >= 0; i--) {
  //     try {
  //       PhotoMemo p = photoMemoList[delIndexes[i]];
  //       await FirestoreController.deletePhotoMemo(photoMemo: p);
  //       await CloudStorageController.deletePhotoFile(photoMemo: p);
  //       state.render(() {
  //         photoMemoList.removeAt(delIndexes[i]);
  //       });
  //     } catch (e) {
  //       if (Constant.DEV) print('====== failed to delete Photomemo: $e');
  //       MyDialog.showSnackBar(
  //         context: state.context,
  //         message: 'Failed to delete Photomemo: $e',
  //       );
  //       break; // quit further processing
  //     }
  //   }
  //   MyDialog.circularProgressStop(state.context);
  //   state.render(() => delIndexes.clear());
  // }

}
