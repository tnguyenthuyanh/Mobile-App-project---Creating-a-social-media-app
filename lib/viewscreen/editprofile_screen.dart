import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfileScreen';
  final User user;

  EditProfileScreen(this.user);

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfileScreen> {
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
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Username',
                  style: TextStyle(
                    fontFamily: 'RockSalt',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '${widget.user.email}',
                  ),
                  enabled: false,
                ),
                Text(
                  'Name',
                  style: TextStyle(
                    fontFamily: 'RockSalt',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  autocorrect: false,
                  validator: con.validateName,
                  onSaved: con.saveName,
                ),
                Text(
                  'Bio',
                  style: TextStyle(
                    fontFamily: 'RockSalt',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Introduce yourself...',
                  ),
                  autocorrect: false,
                  validator: con.validateBio,
                  onSaved: con.saveBio,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: con.update,
                  child: Text(
                    'Update',
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  late _EditProfileState state;
  _Controller(this.state);
  String? email;
  String? password;

  String? validateName(String? value) {
    if (value == null || !(value.contains('.') && value.contains('@')))
      return 'Invalid email address';
    else
      return null;
  }

  void saveName(String? value) {
    if (value != null) email = value;
  }

  String? validateBio(String? value) {
    if (value == null || value.length < 6)
      return 'Invalid password';
    else
      return null;
  }

  void saveBio(String? value) {
    if (value != null) password = value;
  }

  void update() {}
}
