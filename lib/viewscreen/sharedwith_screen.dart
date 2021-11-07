import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';

  final List<PhotoMemo> photoMemoList; // shared with me
  final User user;

  SharedWithScreen({required this.photoMemoList, required this.user});

  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  late _Controller con;

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
        title: Text('Shared With ${widget.user.email}'),
      ),
      body: SingleChildScrollView(
        child: widget.photoMemoList.isEmpty
            ? Text(
                'No PhotoMemos shared with me',
                style: Theme.of(context).textTheme.headline6,
              )
            : Column(
                children: [
                  for (int i = 0; i < widget.photoMemoList.length; i++)
                  // for (var photoMemo in widget.photoMemoList)
                    InkWell(
                      onTap: () => con.navigate2DetailedScreen(i),
                      child: Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: WebImage(
                                url: widget.photoMemoList[i].photoURL,
                                context: context,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                              ),
                            ),
                            Text(
                              widget.photoMemoList[i].title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            Text(widget.photoMemoList[i].memo),
                            Text('Created by: ${widget.photoMemoList[i].createdBy}'),
                            Text('Timestamp: ${widget.photoMemoList[i].timestamp}'),
                            Text('Shared With: ${widget.photoMemoList[i].sharedWith}'),
                            Text('Image Labels: ${widget.photoMemoList[i].imageLabels}'),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _Controller {
  late _SharedWithState state;
  late List<PhotoMemo> photoMemoList;

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }

  void navigate2DetailedScreen(int index) async {
    bool isPhotoSaved = await FirestoreController.isPhotoSaved(
        photoMemo: photoMemoList[index], currentUser: state.widget.user);

    await Navigator.pushNamed(state.context, DetailedViewScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
          ARGS.OnePhotoMemo: photoMemoList[index],
          ARGS.isPhotoSaved: isPhotoSaved,
        });
  }
}
