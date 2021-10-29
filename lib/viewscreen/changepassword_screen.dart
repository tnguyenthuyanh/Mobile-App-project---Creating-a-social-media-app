import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebaseauth_controller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/view/mydialog.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = '/changePasswordScreen';
  final User user;

  ChangePasswordScreen(this.user);

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
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
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'New password',
                ),
                autocorrect: false,
                obscureText: true,
                validator: con.validatePassword,
                onSaved: con.savePassword,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Confirm new password',
                ),
                autocorrect: false,
                obscureText: true,
                validator: con.validatePassword,
                onSaved: con.saveConfirmPassword,
              ),
              ElevatedButton(
                onPressed: con.update,
                style: ElevatedButton.styleFrom(primary: Colors.green[700]),
                child: Text(
                  'Update',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text(
                            'Are you sure you want to delete this account?'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: con.deleteAccount,
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                    child: Text(
                      'Delete Account',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
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
  late _ChangePasswordState state;
  String? password;
  String? passwordConfirm;

  _Controller(this.state);

  void deleteAccount() async {
    await FirebaseAuthController.deleteAccount();
    Navigator.of(state.context).pop(); 
    Navigator.of(state.context).pop(); 
    Navigator.of(state.context).pop(); 
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null || !currentState.validate()) return;

    currentState.save();

    if (password != passwordConfirm) {
      MyDialog.showSnackBar(
        context: state.context,
        message: 'password and confirm do not match',
        seconds: 15,
      );
      return;
    }

    try {
      await FirebaseAuthController.changePassword(password: password!);
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Password Updated!',
      );

      Navigator.of(state.context).pop(); // close the drawer
    } catch (e) {
      if (Constant.DEV) print('====== update Password error: $e');
      MyDialog.showSnackBar(
        context: state.context,
        message: 'Cannot update password: $e',
      );
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.length < 6)
      return 'password too short';
    else
      return null;
  }

  void savePassword(String? value) {
    password = value;
  }

  void saveConfirmPassword(String? value) {
    passwordConfirm = value;
  }
}
