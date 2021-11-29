import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favoritesScreen';
  final User user;
  late final String email;
  final List<PhotoMemo> photoMemoList;

  FavoritesScreen({
    required this.user,
    required this.photoMemoList,
  });

  @override
  State<StatefulWidget> createState() {
    return _FavoritesState();
  }
}

class _FavoritesState extends State<FavoritesScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();

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
          title: Text('Favorites'),
        ),
        body: con.photoMemoList.isEmpty
            ? Text(
                'No PhotoMemo Saved!',
                style: Theme.of(context).textTheme.headline6,
              )
            : ListView.builder(
                itemCount: con.photoMemoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: con.delIndexes.contains(index)
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      leading: WebImage(
                        url: con.photoMemoList[index].photoURL,
                        context: context,
                      ),
                      trailing: Icon(Icons.arrow_right),
                      title: Text(con.photoMemoList[index].title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(con.photoMemoList[index].memo.length >= 40
                              ? con.photoMemoList[index].memo.substring(0, 40) +
                                  '...'
                              : con.photoMemoList[index].memo),
                          Text(
                              'Created By: ${con.photoMemoList[index].createdBy}'),
                          Text(
                              'Shared With: ${con.photoMemoList[index].sharedWith}'),
                          Text(
                              'Timestamp: ${con.photoMemoList[index].timestamp}'),
                        ],
                      ),
                      onTap: () => con.onTap(index),
                      // onLongPress: () => con.onLongPress(index),
                    ),
                  );
                },
              ),
    );
  }
}

class _Controller {
  late _FavoritesState state;
  late List<PhotoMemo> photoMemoList;
  String? searchKeyString;
  List<int> delIndexes = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }

  void onTap(int index) async {
    bool isPhotoSaved = await FirestoreController.isPhotoSaved(
        photoMemo: photoMemoList[index], currentUser: state.widget.user);

    await Navigator.pushNamed(state.context, DetailedViewScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
          ARGS.OnePhotoMemo: photoMemoList[index],
          ARGS.isPhotoSaved: isPhotoSaved,
        });
    Navigator.of(state.context).pop();
  }

}
