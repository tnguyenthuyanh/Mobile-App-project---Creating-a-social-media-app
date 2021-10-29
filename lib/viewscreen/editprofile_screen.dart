import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firestore_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfileScreen';
  final User user;
  final Map profile;

  EditProfileScreen({required this.user, required this.profile});

  @override
  State<StatefulWidget> createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfileScreen> {
  late _Controller con;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool editMode = false;

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
        actions: [
          editMode
              ? IconButton(onPressed: con.update, icon: Icon(Icons.check))
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                )
        ],
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
                  initialValue: con.orgName,
                  autocorrect: false,
                  onSaved: con.saveName,
                  maxLength: 70,
                  enabled: editMode,
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
                  initialValue: con.orgBio,
                  autocorrect: false,
                  onSaved: con.saveBio,
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  maxLength: 200,
                  enabled: editMode,
                ),
                SizedBox(
                  height: 20.0,
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
  late String orgName;
  late String orgBio;

  _Controller(this.state) {
    orgName = state.widget.profile['name'];
    orgBio = state.widget.profile['bio'];
  }

  String? name;
  String? bio;

  void saveName(String? value) {
    if (value != null) name = value;
  }

  void saveBio(String? value) {
    if (value != null) bio = value;
  }

  void edit() async {
    state.render(() => state.editMode = true);
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    MyDialog.circularProgressStart(state.context);

    try {
      await FirestoreController.addUpdateBio(
          user: state.widget.user, name: name!, bio: bio!);
      MyDialog.circularProgressStop(state.context);
      state.render(() => state.editMode = false);
      Navigator.of(state.context).pop();
      Navigator.of(state.context).pop();

    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      if (Constant.DEV) print('====== update bio error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Update bio error: $e',
      );
    }
  }
}
