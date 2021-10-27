import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BioScreen extends StatefulWidget {
  static const routeName = '/bioScreen';
  final User user;

  BioScreen(this.user);

  @override
  State<StatefulWidget> createState() {
    return _BioState();
  }
}

class _BioState extends State<BioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Information'),
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
                        '${widget.user.email}',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 60.0, vertical: 5.0),
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
                                      "3",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 29.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "15,000",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.pinkAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      colors: [Colors.white70, Colors.blue])),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Divider(
                      color: Colors.yellow,
                      height: 30.0, // space betwen top or bottom item
                    ),
                    Text(
                      'Write something here',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
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
