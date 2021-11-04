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
  GlobalKey<FormState> formKey2 = GlobalKey();

  final textController = TextEditingController();

  List<TextEditingController> editController = [];
  List<bool> editEnabled = [];

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
    for (int i = 0; i < con.commentList.length; i++) {
      editController.add(
        TextEditingController(text: con.commentList[i].content),
      );
      editEnabled.add(false);
    }
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Padding(
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
                maxLines: 3,
                validator: Comment.validateComment,
                enabled: true,
              ),
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
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
          con.commentList.isEmpty
              ? Text(
                  'No Comment Yet',
                  style: Theme.of(context).textTheme.headline6,
                )
              : Expanded(
                  child: Form(
                    key: formKey2,
                    child: ListView.builder(
                        itemCount: con.commentList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: TextFormField(
                                    controller: editController[index],
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: con.commentList[index].seen ==
                                              0
                                          ? Colors.purple[200]!.withOpacity(0.4)
                                          : Colors.green[200]!.withOpacity(0.4),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    validator: Comment.validateComment,
                                    autocorrect: false,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 3,
                                    enabled: editEnabled[index],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 2, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${con.commentList[index].commentedBy}',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        '${con.commentList[index].timestamp}',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                                con.commentList[index].uid == widget.user.uid
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 2, 10, 0),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                editEnabled[index]
                                                    ? Expanded(
                                                        child: InkWell(
                                                          onTap: () =>
                                                              con.update(index),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .green[600],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Update",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: InkWell(
                                                          onTap: () =>
                                                              con.edit(index),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .green[600],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Edit",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                editEnabled[index]
                                                    ? Expanded(
                                                        child: InkWell(
                                                          onTap: () =>
                                                              con.cancel(index),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () =>
                                                        con.delete(index),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[400],
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  12),
                                                          topRight:
                                                              Radius.circular(
                                                                  12),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
        ],
      ),
    );
  }
}

class _Controller {
  late _CommentState state;
  late List<Comment> commentList;
  late PhotoMemo photoMemo;
  late Comment comment;
  late Comment tempComment;

  _Controller(this.state) {
    commentList = state.widget.commentList;
    photoMemo = state.widget.photoMemo;
  }

  void update(index) async {
    FormState? currentState = state.formKey2.currentState;
    if (currentState == null || !currentState.validate()) return;
    if (Comment.validateComment(state.editController[index].text) != null) {
      print(state.editController[index].text);
      return;
    }
    currentState.save();

    MyDialog.circularProgressStart(state.context);

    try {
      Map<String, dynamic> updateInfo = {};
      tempComment = Comment.clone(commentList[index]);
      tempComment.content = state.editController[index].text;

      //update Firestore doc
      if (tempComment.content != commentList[index].content) {
        updateInfo[Comment.CONTENT] = tempComment.content;
      }

      if (updateInfo.isNotEmpty) {
        // changes have been made
        tempComment.timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = tempComment.timestamp;
        await FirestoreController.updateComment(
            docId: tempComment.docId!, updateInfo: updateInfo);
        state.widget.commentList[index].assign(tempComment);
      }

      // reorder based on the updated timestamp
      commentList.sort((a, b) {
        if (a.timestamp!.isBefore(b.timestamp!))
          return 1; // descending order
        else if (a.timestamp!.isAfter(b.timestamp!))
          return -1;
        else
          return 0;
      });

      for (int i = 0; i < commentList.length; i++) {
        state.editEnabled[i] = false;
        state.editController[i].text = commentList[i].content;
      }

      MyDialog.circularProgressStop(state.context);
      state.render(() {});
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update comment error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update comment error: $e',
      );
    }
  }

  void delete(int index) async {
    MyDialog.circularProgressStart(state.context);

    await FirestoreController.deleteComment(docId: commentList[index].docId!);
    commentList.removeAt(index);
    state.editController.removeAt(index);
    state.editEnabled.removeAt(index);

    MyDialog.circularProgressStop(state.context);
    state.render(() {});
  }

  void cancel(int index) {
    state.editController[index].text = commentList[index].content;
    state.editEnabled[index] = false;
    state.render(() {});
  }

  void edit(int index) {
    for (int i = 0; i < state.editEnabled.length; i++) {
      state.editEnabled[i] = false;
      state.editController[i].text = commentList[i].content;
    }
    state.editEnabled[index] = true;
    state.render(() {});
  }

  void post() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    try {
      comment.commentedBy = state.widget.user.email!;
      comment.uid = state.widget.user.uid;
      comment.photoId = photoMemo.docId!;
      comment.timestamp = DateTime.now();
      if (photoMemo.uid == state.widget.user.uid)
        comment.seen = 1;
      else
        comment.seen = 0;
      String docId = await FirestoreController.addComment(comment: comment);
      comment.docId = docId;
      state.textController.clear();

      commentList.insert(0, comment);
      state.editEnabled.add(false);
      state.editController.add(TextEditingController());

      // re-order editController
      for (int i = 0; i < commentList.length; i++) {
        state.editEnabled[i] = false;
        state.editController[i].text = commentList[i].content;
      }

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
    if (value != null) {
      comment = Comment();
      comment.content = value;
    }
  }

  // void saveUpdatedComment(String? value) {

  // }
}
