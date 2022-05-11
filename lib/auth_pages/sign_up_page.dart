import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/auth_pages/home_page.dart';
import 'package:task_manager/auth_pages/sign_in.dart';
import 'package:task_manager/global/global.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  // for authentication

  bool circular = false;

  // function to create an account
  validateForm() async {
    try {
      UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim());

      // save data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("uid", user.user!.uid);

      // Save data to firebase
      FirebaseFirestore.instance.collection("users").doc(user.user!.uid).set({
        "uid": user.user!.uid,
        "email": emailTextEditingController.text.trim(),
        "status": "approved",
      });

      //storeTokenAndData(user);
      Fluttertoast.showToast(
          msg: "Successful",
          textColor: Colors.purple,
          backgroundColor: Colors.black12);
      setState(() {
        circular = false;
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

  // // For creating and storing the token of logged in/ registered user
  // final storage = FlutterSecureStorage();
  //
  // // store Token function
  // Future<void> storeTokenAndData(UserCredential userCredential) async {
  //   await storage.write(
  //       key: "token", value: userCredential.credential!.token.toString());
  //
  //   await storage.write(
  //       key: "userCredential", value: userCredential.credential.toString());
  // }
  //
  // // to get token
  // Future<String?> getToken() async {
  //   return await storage.read(key: "token");
  // }

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
                  setState(() {
                    circular = true;
                  });
                  validateForm();
                  // Send Driver to the car Home screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: circular
                      ? CircularProgressIndicator(
                          color: Colors.purple.shade200,
                          backgroundColor: Colors.white,
                        )
                      : Text("REGISTER",
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
                  Text("Have an account ?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    },
                    child: Text("login",
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
