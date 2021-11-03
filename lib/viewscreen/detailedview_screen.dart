import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/cloudstorage_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/controller/googleML_controller.dart';
import 'package:lesson3/model/comment.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/bio_screen.dart';
import 'package:lesson3/viewscreen/comment_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';
import 'package:lesson3/viewscreen/view/webimage.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';

  final User user;
  final PhotoMemo photoMemo;
  final bool isPhotoSaved;

  DetailedViewScreen({
    required this.user,
    required this.photoMemo,
    required this.isPhotoSaved,
  });

  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  late _Controller con;
  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? progressMessage;

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
        title: Text(
          'Detailed View',
        ),
        actions: widget.user.uid == widget.photoMemo.uid
            ? [
                editMode
                    ? IconButton(onPressed: con.update, icon: Icon(Icons.check))
                    : IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: con.edit,
                      )
              ]
            : null,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: con.photo == null
                        ? WebImage(
                            url: con.tempMemo.photoURL,
                            context: context,
                          )
                        : Image.file(con.photo!),
                  ),
                  editMode
                      ? Positioned(
                          right: 0.0,
                          bottom: 0.0,
                          child: Container(
                            color: Colors.blue,
                            child: PopupMenuButton(
                              onSelected: con.getPhoto,
                              itemBuilder: (context) => [
                                for (var source in PhotoSource.values)
                                  PopupMenuItem<PhotoSource>(
                                    value: source,
                                    child: Text(
                                        '${source.toString().split('.')[1]}'),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 1.0,
                        ),
                ],
              ),
              progressMessage == null
                  ? SizedBox(
                      height: 1.0,
                    )
                  : Text(
                      progressMessage!,
                      style: Theme.of(context).textTheme.headline6,
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Posted by ',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: con.navigate2ProfileScreen,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.yellow),
                        ),
                      ),
                      child: Text(
                        widget.photoMemo.createdBy,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                ),
                initialValue: con.tempMemo.title,
                autocorrect: true,
                validator: PhotoMemo.validateTitle,
                onSaved: con.saveTitle,
              ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: 'Enter memo',
                ),
                initialValue: con.tempMemo.memo,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                autocorrect: true,
                validator: PhotoMemo.validateMemo,
                onSaved: con.saveMemo,
              ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: 'Enter sharedWith email list',
                ),
                initialValue: con.tempMemo.sharedWith.join(','),
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                autocorrect: false,
                validator: PhotoMemo.validateSharedWith,
                onSaved: con.saveSharedWith,
              ),
              Constant.DEV
                  ? Text('Image Labels by ML\n${con.tempMemo.imageLabels}')
                  : SizedBox(
                      height: 1.0,
                    ),
              SizedBox(
                height: 10.0,
              ),
              widget.user.uid == widget.photoMemo.uid && editMode == false
                  ? widget.isPhotoSaved
                      ? ElevatedButton(
                          onPressed: con.unsaveFavoritePhoto,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.purple[700]),
                          child: Text('Unsave'),
                        )
                      : ElevatedButton(
                          onPressed: con.saveFavoritePhoto,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[700]),
                          child: Text('Save'),
                        )
                  : SizedBox(),
              Divider(
                color: Colors.blue,
                height: 20.0, // space betwen top or bottom item
              ),
              Container(
                width: 200.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.orange)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white30),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'View Comments',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.comment),
                    ],
                  ),
                  onPressed: con.navigate2CommentScreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _DetailedViewState state;
  late PhotoMemo tempMemo;
  File? photo;

  _Controller(this.state) {
    tempMemo = PhotoMemo.clone(state.widget.photoMemo);
  }

  void navigate2CommentScreen() async {
    List<Comment> commentList =
        await FirestoreController.getCommentList(photoId: tempMemo.docId!);

    await Navigator.pushNamed(state.context, CommentScreen.routeName,
        arguments: {
          ARGS.USER: state.widget.user,
          ARGS.OnePhotoMemo: tempMemo,
          ARGS.commentList: commentList,
        });
  }


  void navigate2ProfileScreen() async {
    try {
      Map profile = await FirestoreController.getBio(uid: tempMemo.uid);
      int numberOfPhotos =
          await FirestoreController.getNumberOfPhotos(uid: tempMemo.uid);
      await Navigator.pushNamed(state.context, BioScreen.routeName, arguments: {
        ARGS.Profile: profile,
        ARGS.USER: state.widget.user,
        ARGS.NumberOfPhotos: numberOfPhotos,
      });
    } catch (e) {
      if (Constant.DEV) print('====== BioScreen error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get BioScreen: $e',
      );
    }
  }

  void unsaveFavoritePhoto() async {
    try {
      await FirestoreController.unsaveFavoritePhoto(
          photoMemo: tempMemo, currentUser: state.widget.user);
      Navigator.of(state.context).pop();
    } catch (e) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to unsave picture: $e',
      );
    }
  }

  void saveFavoritePhoto() async {
    try {
      await FirestoreController.saveFavoritePhoto(
          photoMemo: tempMemo, currentUser: state.widget.user);
      Navigator.of(state.context).pop();
    } catch (e) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to save picture: $e',
      );
    }
  }

  void getPhoto(PhotoSource source) async {
    try {
      var imageSource = source == PhotoSource.CAMERA
          ? ImageSource.camera
          : ImageSource.gallery;
      XFile? image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return; // canceled by camera or gallery
      state.render(() => photo = File(image.path));
    } catch (e) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get a picture: $e',
      );
    }
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);

    try {
      Map<String, dynamic> updateInfo = {};
      if (photo != null) {
        Map photoInfo = await CloudStorageController.uploadPhotoFile(
          photo: photo!,
          uid: state.widget.user.uid,
          filename: tempMemo.photoFilename,
          listener: (int progress) {
            state.render(() {
              state.progressMessage =
                  progress == 100 ? null : 'Uploading: $progress %';
            });
          },
        );
        // generate image labels by ML
        List<String> recognitions =
            await GoogleMLController.getImageLabels(photo: photo!);
        tempMemo.imageLabels = recognitions;

        tempMemo.photoURL = photoInfo[ARGS.DownloadURL];
        updateInfo[PhotoMemo.PHOTO_URL] = tempMemo.photoURL;
        updateInfo[PhotoMemo.IMAGE_LABELS] = tempMemo.imageLabels;
      }

      //update Firestore doc
      if (tempMemo.title != state.widget.photoMemo.title)
        updateInfo[PhotoMemo.TITLE] = tempMemo.title;
      if (tempMemo.memo != state.widget.photoMemo.memo)
        updateInfo[PhotoMemo.MEMO] = tempMemo.memo;
      if (!listEquals(tempMemo.sharedWith, state.widget.photoMemo.sharedWith))
        updateInfo[PhotoMemo.SHARED_WITH] = tempMemo.sharedWith;

      if (updateInfo.isNotEmpty) {
        // changes have been made
        tempMemo.timestamp = DateTime.now();
        updateInfo[PhotoMemo.TIMESTAMP] = tempMemo.timestamp;
        await FirestoreController.updatePhotoMemo(
          docId: tempMemo.docId!,
          updateInfo: updateInfo,
        );
        state.widget.photoMemo.assign(tempMemo);
      }

      MyDialog.circularProgressStop(state.context);
      state.render(() => state.editMode = false);
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update photomemo error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update PhotoMemo error: $e',
      );
    }
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void saveTitle(String? value) {
    if (value != null) tempMemo.title = value;
  }

  void saveMemo(String? value) {
    if (value != null) tempMemo.memo = value;
  }

  void saveSharedWith(String? value) {
    if (value != null && value.trim().length != 0) {
      tempMemo.sharedWith.clear();
      tempMemo.sharedWith.addAll(value.trim().split(RegExp('(,| )+')));
    }
  }
}
