import 'package:flutter/material.dart';
import 'package:wally_app/auth.dart';

class SignOutPage extends StatefulWidget {
  const SignOutPage({super.key});

  @override
  State<SignOutPage> createState() => _State();
}

class _State extends State<SignOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text("Do you wanna leave us already?",
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w700,
                  ))),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.width * .6,
                child: ElevatedButton(
                    onPressed: () {
                      Auth().deleteUser();
                      setState(() {});
                    },
                    child: const Text("Delete account",
                        style: TextStyle(
                          fontSize: 30,
                        ))),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .2,
                width: MediaQuery.of(context).size.width * .6,
                child: ElevatedButton(
                    onPressed: () {
                      Auth().signOut();
                      setState(() {});
                    },
                    child: const Text("Sign out",
                        style: TextStyle(
                          fontSize: 30,
                        ))),
              ),
            ],
          ),
        ));
  }
}
