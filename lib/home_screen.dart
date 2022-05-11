import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/global/global.dart';
import 'package:task_manager/screen_pages/add_todo.dart';

import 'utils/date_utils.dart' as date_util;

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double width = 0.0;
  double height = 0.0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  List<String> todos_des = <String>[];
  TextEditingController controller = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController timeIntervalController = TextEditingController();

  // Timer slider value
  double timeInterval = 0.0;

  //RangeValues values = RangeValues(_startTime, _endTime);
  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  Widget backgroundView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddTodo()));
            },
            child: ImageIcon(
              AssetImage("assets/fourdots.png"),
              size: 22,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.25, right: width * 0.25),
            child: Text(
              "Create Task",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                //fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          ImageIcon(
            AssetImage("assets/clock.png"),
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget hrizontalCapsuleListView() {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (currentMonthList[index].day != currentDateTime.day)
                  ? Color(0xFFf2f2f2)
                  : Color(0xFF4044c7),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? Colors.black
                                : Colors.white),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 12,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? Color(0xFF4044c7)
                                : Color(0xFFf2f2f2)),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget topView() {
    return Container(
      height: height * 0.35,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            titleView(),
            hrizontalCapsuleListView(),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: height * 0.035),
                  child: Text(
                    "Chose activity",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  // In this function we are writting code
  // create new data in firebase cloud Firestore
  createTodo(String title, String number, String timeInterval) {
    // Create a new Collection
    DocumentReference documentReference = firestore.collection("MyTodos").doc();

    // currentDateTime.day.toString() +
    //     currentDateTime.month.toString() +
    //     items_in_todo.toString()
    Map<String, String> todoList = {
      "todoTitle": title,
      "todoNumber": number,
      "timeInterval": timeInterval,
      "date": currentDateTime.day.toString(),
      "month": currentDateTime.month.toString(),
      "isCompleted": "false",
    };

    // uploading data on Firebase
    documentReference.set(todoList).whenComplete(
          () => print("Data Stored Successfully !"),
        );
  }

  Widget floatingActionBtn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Container(
          width: 100,
          height: 100,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            shape: BoxShape.rectangle,
            color: Color(0xFF4044c7),
          ),
        ),
        onPressed: () {
          controller.text = "";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Color(0xFF4044c7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 260,
                    width: 320,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Add Todo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: controller,
                          cursorColor: Color(0xFFf2f2f2),
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Add your new todo item',
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: summaryController,
                          keyboardType: TextInputType.number,
                          cursorColor: Color(0xFFf2f2f2),
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Task Number',
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: timeIntervalController,
                          keyboardType: TextInputType.datetime,
                          cursorColor: Color(0xFFf2f2f2),
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Estimated Time',
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // StatefulBuilder(builder: (context, state) {
                        //   return RangeSlider(
                        //       values: values,
                        //       labels: RangeLabels(
                        //           values.start.round().toString(),
                        //           values.end.round().toString()),
                        //       activeColor: Colors.white,
                        //       inactiveColor: Colors.black,
                        //       min: _startTime,
                        //       max: _endTime,
                        //       onChanged: (val) {
                        //         print(val);
                        //         state(() {
                        //           values = val;
                        //         });
                        //         setState(() {
                        //           values = val;
                        //         });
                        //       });
                        // }),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              primary: Color(0xFFf2f2f2),
                            ),
                            onPressed: () {
                              // setState(() {
                              //   todos.add(controller.text);
                              //   todos_des.add(summaryController.text);
                              // });
                              setState(() {
                                items_in_todo += 1;
                                createTodo(
                                    controller.text,
                                    summaryController.text,
                                    timeIntervalController.text);
                              });
                              // uploadDataOnFirebase(
                              //     controller.text, summaryController.text);
                              setState(() {
                                controller.clear();
                                summaryController.clear();
                                timeIntervalController.clear();
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Add Todo",
                              style: TextStyle(
                                color: Color(0xFF4044c7),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget todoList() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, height * 0.31, 10, 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      width: width,
      height: height * 0.60,
      child: ListView.builder(
          itemCount: todos.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
              width: width - 20,
              height: 70,
              decoration: BoxDecoration(
                  color: Color(0xFFf2f2f2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.white12,
                        blurRadius: 2,
                        offset: Offset(2, 2),
                        spreadRadius: 3)
                  ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1),
                        child: Text(
                          todos[index],
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.bottomCenter,
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.deepPurple.shade500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1),
                    child: Text(
                      todos_des[index] + " on this week",
                      style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget? todoListLive() {
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream:
            firestore.collection("MyTodos").orderBy("todoNumber").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  QueryDocumentSnapshot<Object?>? documentSnapshot =
                      snapshot.data?.docs[index];
                  return (documentSnapshot!["date"] ==
                          currentDateTime.day.toString())
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Dismissible(
                              key: Key(index.toString()),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                width: width - 20,
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Color(0xFFf2f2f2),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.white12,
                                          blurRadius: 2,
                                          offset: Offset(2, 2),
                                          spreadRadius: 3)
                                    ]),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.1),
                                          child: Text(
                                            (documentSnapshot != null)
                                                ? (documentSnapshot[
                                                    "todoTitle"])
                                                : "",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                          alignment: Alignment.bottomCenter,
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: Colors.deepPurple.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1),
                                      child: Text(
                                        (documentSnapshot != null)
                                            ? (documentSnapshot["todoNumber"]) +
                                                " on this day"
                                            : "",
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              backgroundView(),
              topView(),
              todoListLive()!,
            ],
          ),
        ),
        floatingActionButton: floatingActionBtn());
  }
}
