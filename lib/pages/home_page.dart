import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wally_app/auth.dart';
import 'package:wally_app/pages/profile_page.dart';
import 'package:wally_app/pages/signout_page.dart';
import 'package:wally_app/pages/wallet_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Wally');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                title: _title(),
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.attach_money_sharp)),
                    Tab(icon: Icon(Icons.point_of_sale)),
                    Tab(icon: Icon(Icons.door_front_door_outlined)),
                  ],
                )),
            body: const TabBarView(
              children: [
                ProfilePage(),
                WalletPage(),
                SignOutPage(),
              ],
            )));
  }
}
