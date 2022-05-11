import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/global/global.dart';
import 'package:task_manager/home_screen.dart';
import 'package:task_manager/splash_screen.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // if listTile selected
    bool isTileSelected = false;
    Color selectedTileColor = Color(0xff4044c9);
    Color selectedTextColor = Colors.white;
    Color unSelectedTileColor = Colors.grey.shade200;
    Color unSelectedTextColor = Colors.black;
    bool isChecked = false;
    var MONTHS = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String formattedDateTime() {
      DateTime now = new DateTime.now();
      return now.day.toString() +
          " " +
          MONTHS[now.month - 1] +
          " " +
          now.year.toString();
    }

    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color(0xff4044c9);
      }
      return Colors.grey.shade400;
    }

    DateTime now = new DateTime.now();
    return Scaffold(
      backgroundColor: Color(0xff4044c9),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff4044c9),
          //toolbarHeight: MediaQuery.of(context).size.height * 0.3,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                formattedDateTime(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          leading: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.045),
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Color(0xff4044c9),
                        title: Container(
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: Column(
                            children: [
                              Text(
                                "Do you really want to Sign out?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 50,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      firebaseAuth.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MySplashScreen()));
                                    },
                                    child: Container(
                                      child: Text(
                                        "YES",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: ImageIcon(
                AssetImage("assets/fourdots.png"),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.01),
              child: IconButton(
                onPressed: () {},
                icon: ImageIcon(
                  AssetImage("assets/clock.png"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "8 tasks",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(title: "Add Todo")));
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Add New",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff4044c9),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 25,
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                              color: Color(0xff4044c9),
                              borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.centerLeft,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentDateTime.day.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  MONTHS[currentDateTime.month - 1],
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: firestore
                              .collection("MyTodos")
                              .orderBy("timeInterval", descending: false)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData || snapshot.data != null) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    QueryDocumentSnapshot<Object?>?
                                        documentSnapshot =
                                        snapshot.data?.docs[index];

                                    return (documentSnapshot!["date"] ==
                                            currentDateTime.day.toString())
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.02),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                            height: 70,
                                            child: ListTile(
                                              tileColor: selectedTileColor,
                                              selected: isTileSelected,
                                              selectedTileColor:
                                                  selectedTileColor,
                                              onTap: () {
                                                print("tapped");
                                                setState(() {
                                                  isTileSelected =
                                                      !isTileSelected;
                                                });
                                              },
                                              title: Text(
                                                (documentSnapshot != null)
                                                    ? (documentSnapshot[
                                                        "todoTitle"])
                                                    : "",
                                                style: TextStyle(
                                                  color: isTileSelected
                                                      ? selectedTextColor
                                                      : unSelectedTextColor,
                                                ),
                                              ),
                                              subtitle: Text(
                                                (documentSnapshot != null)
                                                    ? (documentSnapshot[
                                                            "timeInterval"]) +
                                                        " hr"
                                                    : "",
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                ),
                                              ),
                                              leading: Checkbox(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.5),
                                                ),
                                                fillColor: documentSnapshot[
                                                            "isCompleted"] ==
                                                        "true"
                                                    ? MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.deepPurple)
                                                    : MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.grey),
                                                checkColor: Colors.white,
                                                activeColor: Colors.deepPurple,
                                                value: isChecked,
                                                onChanged:
                                                    (bool? newValue) async {
                                                  setState(() {
                                                    isChecked = newValue!;
                                                  });
                                                  String title =
                                                      documentSnapshot[
                                                          "todoTitle"];
                                                  String number =
                                                      documentSnapshot[
                                                          "todoNumber"];
                                                  String isCompleted = "true";
                                                  String month =
                                                      documentSnapshot["month"];
                                                  String timeInterval =
                                                      documentSnapshot["month"];
                                                  String date =
                                                      documentSnapshot["date"];

                                                  FirebaseFirestore.instance
                                                      .collection("MyTodos")
                                                      .doc(documentSnapshot.id)
                                                      .update({
                                                    "date": date,
                                                    "isCompleted": isCompleted,
                                                    "month": month,
                                                    "todoTitle": title,
                                                  }).whenComplete(() => print(
                                                          "Updated successfully"));

                                                  // Map<String, String> todoList =
                                                  //     {
                                                  //   "date": documentSnapshot[
                                                  //       "date"],
                                                  //   "isCompleted": "true",
                                                  // };

                                                  // updating data on Firebase

                                                  // documentReference
                                                  //     .delete()
                                                  //     .whenComplete(() => print(
                                                  //         "Data deleted !"));
                                                  // documentReference
                                                  //     .update(todoList)
                                                  //     .whenComplete(
                                                  //       () => print(
                                                  //           "Data Updated Successfully !"),
                                                  //     );
                                                },
                                              ),
                                            ),
                                          )
                                        : Container(
                                            // color: Colors.white,
                                            );
                                  });
                            }
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepPurple,
                                ),
                              ),
                            );
                          })
                      // Row(
                      //   children: [
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Color(0xff4044c9),
                      //         borderRadius: BorderRadius.circular(20),
                      //       ),
                      //       padding: EdgeInsets.all(20),
                      //       child: Text(
                      //         now.day.toString(),
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 18,
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.07,
                      //     ),
                      //     Text(
                      //       "8 hours a day",
                      //       style: TextStyle(color: Colors.grey),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
