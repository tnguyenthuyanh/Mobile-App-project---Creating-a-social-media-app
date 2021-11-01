import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/editprofile_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class BioScreen extends StatefulWidget {
  static const routeName = '/bioScreen';
  final User user;
  final Map profile;
  final int numberOfPhotos;

  BioScreen(
      {required this.user,
      required this.profile,
      required this.numberOfPhotos});

  @override
  State<StatefulWidget> createState() {
    return _BioState();
  }
}

class _BioState extends State<BioScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        title: Text('Profile'),
        actions: widget.profile['uid'] == widget.user.uid
            ? [IconButton(onPressed: con.edit, icon: Icon(Icons.edit))]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.black,
                    Colors.blueAccent,
                    Colors.pinkAccent
                  ])),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.profile['name'] == ""
                            ? "N/A"
                            : widget.profile['name'],
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                         widget.profile['email'],
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 110.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.green[50],
                        elevation: 7.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Images",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 29.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      widget.numberOfPhotos.toString(),
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Expanded(
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         "Followers",
                              //         style: TextStyle(
                              //           color: Colors.orange,
                              //           fontSize: 29.0,
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         height: 5.0,
                              //       ),
                              //       Text(
                              //         "15,000",
                              //         style: TextStyle(
                              //           fontSize: 20.0,
                              //           color: Colors.pinkAccent,
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      colors: [
                    Colors.blue,
                    Colors.orange[200]!,
                  ])),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio:',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18.0,
                      ),
                    ),
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                    Text(
                      widget.profile['bio'],
                      maxLines: 6,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
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
  late _BioState state;
  _Controller(this.state);

  void edit() async {
    try {
      Map profile = await FirestoreController.getBio(uid: state.widget.user.uid);
      await Navigator.pushNamed(state.context, EditProfileScreen.routeName,
          arguments: {
            ARGS.Profile: profile,
            ARGS.USER: state.widget.user,
          });
    } catch (e) {
      if (Constant.DEV) print('====== editProfile error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Failed to get editProfile: $e',
      );
    }
  }
}
