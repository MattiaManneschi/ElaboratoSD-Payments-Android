// pagina principale dove vengono riassunti i punti dell'utente e le offerte disponibili

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wally_app/main.dart';
import 'package:wally_app/auth.dart';

int currentPoints = 0;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static void addPoints(int points) {  // aggiunge i punti all'utente dopo aver pagato 
    final docRef = db.doc(Auth().currentUser?.email); // prende l'istanza dello user corrente dal db, identificato in maniera univoca dall'email
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      currentPoints = data['points']; // prende i punti correnti dell'utente
    });
    currentPoints += points; // maggiorazione
    docRef.update({"points": currentPoints}); //aggiornamento dei punti
  }
}

class _ProfilePageState extends State<ProfilePage> {
  bool showWidget = false;

  var isPressed = [false, false, false, false]; // isPressed e il metodo successivo servono per tenere attiva l'offerta selezionata dall'utente e
                                                // "spegnere" tutte le altre
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

  int getPoints() {  //metodo che ritorna i punti correnti (serve solo alla GUI per far sapere all'utente quanti punti ha)
    final docRef = db.doc(Auth().currentUser?.email);
    docRef.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      currentPoints = data['points'];
    }, onError: (e) => print("$e"));
    return currentPoints;
  }

  bool removePoints(int points) {  // rimuove i punti dopo un ordine
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
