import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/auth_pages/sign_up_page.dart';
import 'package:task_manager/home_screen.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();

  // for authentication
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool circular = false;

  // function to create an account
  validateForm() async {
    try {
      UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim());

      Fluttertoast.showToast(
          msg: "Successful",
          textColor: Colors.purple,
          backgroundColor: Colors.black12);
      setState(() {
        circular = true;
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          textColor: Colors.purple,
          backgroundColor: Colors.black12);
      setState(() {
        circular = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: Image.asset("images/ally_nobg.png"),
              // ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Text(
                  "MATLYNC",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),

              // To get the email of the driver
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.cyan),
                decoration: const InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purple,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),

              // To get the password of the driver
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: TextStyle(color: Colors.cyan),
                decoration: const InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.purple,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                  // Send Driver to the car Home screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Todo")));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: circular
                      ? CircularProgressIndicator(
                          color: Colors.purple.shade200,
                          backgroundColor: Colors.white,
                        )
                      : Text("LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: circular ? 0 : 10,
                  primary: circular
                      ? Colors.white
                      : Color.fromARGB(255, 117, 66, 236),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account ?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage()));
                    },
                    child: Text("Register",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),

              // InkWell(
              //   borderRadius: BorderRadius.circular(15),
              //   splashColor: Colors.purple.shade200,
              //   onTap: () {
              //     print("tapped");
              //   },
              //   child: Container(
              //     height: 60,
              //     width: MediaQuery.of(context).size.width - 60,
              //     child: Card(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       shadowColor: Colors.purple.shade200,
              //       elevation: 15,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //           SvgPicture.asset(
              //             "assets/google.svg",
              //             width: 30,
              //           ),
              //           Text(
              //             "Continue with Google".toUpperCase(),
              //             style: TextStyle(
              //               fontSize: 17,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
