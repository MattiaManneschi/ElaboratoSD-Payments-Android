import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wally_app/pages/profile_page.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int selected = 0;
  int money = 1;

  var isPressed = [false, false, false, false, false];

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
  static const platform = MethodChannel('nexi.payment/gateway');

  @override
  void initState() {
    super.initState();
  }

  void setSelected(int s) {
    selected = s;
    money = s * 50;
  }

  bool check() {
    if (selected != 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _pay() async {
    if (check()) {
      try {
        final int points =
            await platform.invokeMethod("pay", {'amount': money});
        ProfilePage.addPoints(points);
      } on PlatformException catch (e) {
        Text("$e.message");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Stack(alignment: Alignment.bottomRight, children: <Widget>[
          Container(
              alignment: const Alignment(1, 1),
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(1, 100, 1, 1),
                  child: Text(
                    'Choose your pack',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xff262626),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[0]
                              ? Colors.amber
                              : const Color(0x00031bd4),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            setSelected(5);
                            setButton(0);
                          });
                        },
                        child: const Text('5'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[1]
                              ? Colors.amber
                              : const Color(0x00031bd4),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            setSelected(10);
                            setButton(1);
                          });
                        },
                        child: const Text('10'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[2]
                              ? Colors.amber
                              : const Color(0x00031bd4),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            setSelected(20);
                            setButton(2);
                          });
                        },
                        child: const Text('20'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[3]
                              ? Colors.amber
                              : const Color(0x00031bd4),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            setSelected(50);
                            setButton(3);
                          });
                        },
                        child: const Text('50'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPressed[4]
                              ? Colors.amber
                              : const Color(0x00031bd4),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            setSelected(100);
                            setButton(4);
                          });
                        },
                        child: const Text('100'),
                      ),
                    ])
              ])),
          Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("You selected $selected points",
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: SizedBox(
                  height: 75,
                  width: MediaQuery.of(context).size.width * .50,
                  child: ElevatedButton(
                      onPressed: () {
                        _pay();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(15)),
                      child: const Text('REFILL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ))),
                ),
              ),
            ],
          ),
        ])
      ]),
    );
  }
}
