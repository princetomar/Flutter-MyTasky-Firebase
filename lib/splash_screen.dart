import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager/auth_pages/sign_in.dart';
import 'package:task_manager/global/global.dart';
import 'package:task_manager/screen_pages/add_todo.dart';

class MySplashScreen extends StatefulWidget {
  MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  // for how much time do we need to show the splash screen to the driver
  startTimer() {
    Timer(Duration(seconds: 4), () async {
      // Check if the user is logged in or not
      if (firebaseAuth.currentUser != null) {
        // user is logged in

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddTodo()));
      } else {
        // send user to the home screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInPage()));
      }
    });
  }

  // Whenever the user navigate's to the current screen
  // all the methods inside initState() will be called first.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    _animation = CurvedAnimation(parent: _controller!, curve: Curves.easeIn);

    // _controller.repeat(reverse: false);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            "images/matlyncnobg.png",
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.8,
          ),
          Text(
            "MATLYNC",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 44,
              color: Colors.cyan,
            ),
          ),
        ]),
      ),
    );
  }
}
