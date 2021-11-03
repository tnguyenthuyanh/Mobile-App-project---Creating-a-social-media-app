import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/addnewphotomemo_screen.dart';
import 'package:lesson3/viewscreen/bio_screen.dart';
import 'package:lesson3/viewscreen/changepassword_screen.dart';
import 'package:lesson3/viewscreen/comment_screen.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/editprofile_screen.dart';
import 'package:lesson3/viewscreen/favorites_screen.dart';
import 'package:lesson3/viewscreen/internalerror_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/signin_screen.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Lesson3App());
}

class Lesson3App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.DEV,
      theme: ThemeData(
        brightness: Constant.DARKMODE ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blueAccent,
      ),
      initialRoute: SignInScreen.routeName,
      routes: {
        SignInScreen.routeName: (context) => SignInScreen(),
        ChangePasswordScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at ChangePassword');
          } else {
            return ChangePasswordScreen(args as User);
          }
        },
        BioScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at BioScreen');
          } else {
             var argument = args as Map;
            var user = argument[ARGS.USER];
            var profile = argument[ARGS.Profile];
            var numberOfPhotos = argument[ARGS.NumberOfPhotos];
            return BioScreen(user: user, profile: profile, numberOfPhotos: numberOfPhotos,);
          }
        },
        EditProfileScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at EditProfileScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var profile = argument[ARGS.Profile];
            return EditProfileScreen(user: user, profile: profile);
          }
        },
        FavoritesScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at FavoritesScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return FavoritesScreen(user: user, photoMemoList: photoMemoList);
          }
        },
        CommentScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at CommentScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            var commentList = argument[ARGS.commentList];
            return CommentScreen(
              user: user,
              photoMemo: photoMemo,
              commentList: commentList,
            );
          }
        },
        UserHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at UserHomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return UserHomeScreen(user: user, photoMemoList: photoMemoList);
          }
        },
        SharedWithScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at SharedWithScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return SharedWithScreen(user: user, photoMemoList: photoMemoList);
          }
        },
        AddNewPhotoMemoScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at AddNewPhotoMemoScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemoList = argument[ARGS.PhotoMemoList];
            return AddNewPhotoMemoScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        DetailedViewScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return InternalErrorScreen('args is null at DetailedViewScreen');
          } else {
            var argument = args as Map;
            var user = argument[ARGS.USER];
            var photoMemo = argument[ARGS.OnePhotoMemo];
            var isPhotoSaved = argument[ARGS.isPhotoSaved];
            return DetailedViewScreen(
              user: user,
              photoMemo: photoMemo,
              isPhotoSaved: isPhotoSaved,
            );
          }
        },
        SignUpScreen.routeName: (context) => SignUpScreen(),
      },
    );
  }
}
