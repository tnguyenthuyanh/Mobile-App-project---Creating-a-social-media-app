import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/addnewphotomemo_screen.dart';
import 'package:lesson3/viewscreen/bio_screen.dart';
import 'package:lesson3/viewscreen/changepassword_screen.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/favorites_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class UserHomeScreen extends StatefulWidget {
  static const routeName = '/userHomeScreen';
  final User user;
  late final String email;
  final List<PhotoMemo> photoMemoList;

  UserHomeScreen({
    required this.user,
    required this.photoMemoList,
  }) {
    email = user.email ?? 'no email'; // if email is null print no email
  }

  @override
  State<StatefulWidget> createState() {
    return _UserHomeState();
  }
}

class _UserHomeState extends State<UserHomeScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey();
  Sort sortValue = Sort.MostRecent;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          Future.value(false), // disable Android system back button
      child: Scaffold(
        appBar: AppBar(
          // title: Text('User Home'),
          actions: [
            con.delIndexes.isEmpty
                ? Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextFormField(
                          style: TextStyle(fontSize: 12.0, height: 1.5),
                          decoration: InputDecoration(
                            hintText: 'Search (empty for all)',
                            fillColor: Theme.of(context).backgroundColor,
                            filled: true,
                          ),
                          autocorrect: true,
                          onSaved: con.saveSearchKey,
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: con.cancelDelete,
                    icon: Icon(Icons.cancel),
                  ),
            con.delIndexes.isEmpty
                ? IconButton(
                    onPressed: con.search,
                    icon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                  )
                : IconButton(
                    onPressed: con.delete,
                    icon: Icon(Icons.delete),
                  ),
            con.delIndexes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                    child: Container(
                      width: 130,
                      padding: const EdgeInsets.only(left: 7.0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        color: Colors.grey.withAlpha(100),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Sort>(
                          value: sortValue,
                          onChanged: con.sort,
                          items: [
                            for (var c in Sort.values)
                              DropdownMenuItem<Sort>(
                                child: Text(
                                  c.toString().split('.')[1],
                                  style: TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                                value: c,
                              ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('Hello!'),
                accountEmail: Text(widget.email),
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('Shared With'),
                onTap: con.sharedWith,
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: con.favorites,
              ),
              ListTile(
                leading: Icon(Icons.account_box_outlined),
                title: Text('My Profile'),
                onTap: con.seeProfile,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Change Password'),
                onTap: con.changePassword,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                onTap: con.signOut,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: con.addButton,
        ),
        body: con.photoMemoList.isEmpty
            ? Text(
                'No PhotoMemo found!',
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
                      trailing: con.photoMemoList[index].new_comments == 0
                          ? null
                          : Container(
                              height: 34,
                              width: 34,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.purple),
                              child: Center(
                                child: Wrap(
                                  children: [
                                    Icon(
                                      Icons.comment,
                                      size: 15,
                                    ),
                                    Text(
                                      con.photoMemoList[index].new_comments
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                      onLongPress: () => con.onLongPress(index),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Controller {
  late _UserHomeState state;
  late List<PhotoMemo> photoMemoList;
  String? searchKeyString;
  List<int> delIndexes = [];

  _Controller(this.state) {
    photoMemoList = state.widget.photoMemoList;
  }

  void favorites() async {
    try {
      List<PhotoMemo> photoMemoList =
          await FirestoreController.getFavoriteList(uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, FavoritesScreen.routeName,
          arguments: {
            ARGS.PhotoMemoList: photoMemoList,
            ARGS.USER: state.widget.user,
          });
      Navigator.of(state.context).pop(); // close the drawer

    } catch (e) {
      if (Constant.DEV) print('====== Favorites error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get Favorite List: $e',
      );
    }
  }

  void changePassword() async {
    try {
      await Navigator.pushNamed(
        state.context,
        ChangePasswordScreen.routeName,
        arguments: state.widget.user,
      );
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.DEV) print('====== ChangePassword error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get changePassword: $e',
      );
    }
  }

  void seeProfile() async {
    try {
      Map profile =
          await FirestoreController.getBio(uid: state.widget.user.uid);
      int numberOfPhotos = await FirestoreController.getNumberOfPhotos(
          uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, BioScreen.routeName, arguments: {
        ARGS.Profile: profile,
        ARGS.USER: state.widget.user,
        ARGS.NumberOfPhotos: numberOfPhotos,
      });
      // close the drawer
      Navigator.of(state.context).pop();
    } catch (e) {
      if (Constant.DEV) print('====== BioScreen error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }

  void sharedWith() async {
    try {
      List<PhotoMemo> photoMemoList =
          await FirestoreController.getPhotoMemoListSharedWith(
              email: state.widget.email);
      await Navigator.pushNamed(state.context, SharedWithScreen.routeName,
          arguments: {
            ARGS.PhotoMemoList: photoMemoList,
            ARGS.USER: state.widget.user,
          });
      Navigator.of(state.context).pop(); // close the drawer

    } catch (e) {
      if (Constant.DEV) print('====== sharedWith error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get sharedwith List: $e',
      );
    }
  }

  void delete() async {
    MyDialog.circularProgressStart(state.context);
    delIndexes.sort(); // ascending order
    for (int i = delIndexes.length - 1; i >= 0; i--) {
      try {
        PhotoMemo p = photoMemoList[delIndexes[i]];
        await FirestoreController.deletePhotoMemo(photoMemo: p);
        await CloudStorageController.deletePhotoFile(photoMemo: p);
        state.render(() {
          photoMemoList.removeAt(delIndexes[i]);
        });
      } catch (e) {
        if (Constant.DEV) print('====== failed to delete Photomemo: $e');
        MyDialog.showSnackBar(
          context: state.context,
          message: 'Failed to delete Photomemo: $e',
        );
        break; // quit further processing
      }
    }
    MyDialog.circularProgressStop(state.context);
    state.render(() => delIndexes.clear());
  }

  void cancelDelete() {
    state.render(() {
      delIndexes.clear();
    });
  }

  void onLongPress(int index) {
    state.render(() {
      if (delIndexes.contains(index))
        delIndexes.remove(index);
      else
        delIndexes.add(index);
    });
  }

  void saveSearchKey(String? value) {
    searchKeyString = value;
  }

  void search() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    currentState.save();

    List<String> keys = [];
    if (searchKeyString != null) {
      var tokens = searchKeyString!.split(RegExp('(,| )+')).toList();
      for (var t in tokens) {
        if (t.trim().isNotEmpty) keys.add(t.trim().toLowerCase());
      }
    }

    MyDialog.circularProgressStart(state.context);

    try {
      late List<PhotoMemo> results;
      if (keys.isEmpty) {
        // read all photomemos
        results = await FirestoreController.getPhotoMemoList(
            uid: state.widget.user.uid);
      } else {
        results = await FirestoreController.searchImages(
          createdBy: state.widget.email,
          searchLabels: keys,
        );
      }
      MyDialog.circularProgressStop(state.context);
      state.render(() => photoMemoList = results);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('========= search error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Search error: $e',
      );
    }
  }

  void onTap(int index) async {
    if (delIndexes.isNotEmpty) {
      onLongPress(index);
      return;
    }
    bool isPhotoSaved = await FirestoreController.isPhotoSaved(
        photoMemo: photoMemoList[index], currentUser: state.widget.user);

    List<Comment> commentList = await FirestoreController.getCommentList(
        photoId: photoMemoList[index].docId!);

    await Navigator.pushNamed(state.context, DetailedViewScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
          ARGS.OnePhotoMemo: photoMemoList[index],
          ARGS.isPhotoSaved: isPhotoSaved,
          ARGS.commentList: commentList,
        });
    // rerender home screen
    state.render(() {
      // reorder based on the updated timestamp
      photoMemoList.sort((a, b) {
        if (a.timestamp!.isBefore(b.timestamp!))
          return 1; // descending order
        else if (a.timestamp!.isAfter(b.timestamp!))
          return -1;
        else
          return 0;
      });
    });
  }

  void addButton() async {
    // navigate to AddNewPhotoMemo
    await Navigator.pushNamed(
      state.context,
      AddNewPhotoMemoScreen.routeName,
      arguments: {
        ARGS.USER: state.widget.user,
        ARGS.PhotoMemoList: photoMemoList,
      },
    );
    state.render(() {}); // rerender the home screen if new photomemo is added
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuthController.signOut();
    } catch (e) {
      if (Constant.DEV) print('===== sign out error: $e');
    }
    Navigator.of(state.context).pop(); // close the drawer
    Navigator.of(state.context).pop(); // pop from UserHome
  }

  Future<void> sort(Sort? value) async {
    MyDialog.circularProgressStart(state.context);

    try {
      List<PhotoMemo> results = await FirestoreController.sort(
        uid: state.widget.user.uid,
        option: value!,
      );

      MyDialog.circularProgressStop(state.context);

      state.render(() {
        state.sortValue = value;
        photoMemoList = results;
      });
      
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('========= sort error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Sort error: $e',
      );
    }
  }
}
