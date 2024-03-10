import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wally_app/main.dart';
import 'package:wally_app/auth.dart';

int currentPoints = 0;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static void addPoints(int points) {
    final docRef = db.doc(Auth().currentUser?.email);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      currentPoints = data['points'];
    });
    currentPoints += points;
    docRef.update({"points": currentPoints});
  }
}

class _ProfilePageState extends State<ProfilePage> {
  bool showWidget = false;

  var isPressed = [false, false, false, false];

  void setButton(int k) {
    for (int i = 0; i < isPressed.length; i++) {
      if (i == k) {
        isPressed[i] = true;
      } else {
        isPressed[i] = false;
      }
    }
  }

  TextEditingController myController = TextEditingController();
  String response = '';

  int getPoints() {
    final docRef = db.doc(Auth().currentUser?.email);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      currentPoints = data['points'];
    }, onError: (e) => print("$e"));
    return currentPoints;
  }

  bool removePoints(int points) {
    int currentPoints = getPoints();
    if (currentPoints >= points) {
      currentPoints -= points;
      db.doc(Auth().currentUser?.email).update({'points': currentPoints});
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('You have ${getPoints()} points',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[0]
                              ? Colors.amber
                              : const Color(0x00031bd4)),
                      onPressed: () {
                        setState(() {
                          showWidget = !showWidget;
                          setButton(0);
                        });
                      },
                      child: const Text('Public transport ticket',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[1]
                              ? Colors.amber
                              : const Color(0x00031bd4)),
                      onPressed: () {
                        setState(() {
                          showWidget = !showWidget;
                          setButton(1);
                        });
                      },
                      child: const Text('Amazon voucher',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[2]
                              ? Colors.amber
                              : const Color(0x00031bd4)),
                      onPressed: () {
                        setState(() {
                          showWidget = !showWidget;
                          setButton(2);
                        });
                      },
                      child: const Text('Zalando voucher',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 70,
                  width: MediaQuery.of(context).size.width * .6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[3]
                              ? Colors.amber
                              : const Color(0x00031bd4)),
                      onPressed: () {
                        setState(() {
                          showWidget = !showWidget;
                          setButton(3);
                        });
                      },
                      child: const Text('Eneba voucher',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700))),
                ),
              ],
            ),
            Column(
              children: [
                showWidget
                    ? TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            hintText: 'Amount of points',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                  style: BorderStyle.solid,
                                )),
                            suffixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showWidget = !showWidget;
                                        removePoints(
                                                int.parse(myController.text))
                                            ? response = "Order completed!"
                                            : response = "Insufficient points!";
                                      });
                                    },
                                    child: const Text('Complete Order')))),
                      )
                    : Text(response,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700))
              ],
            )
          ],
        ),
      ),
    );
  }
}
