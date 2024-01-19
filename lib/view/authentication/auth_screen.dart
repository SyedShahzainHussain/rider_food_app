import 'package:flutter/material.dart';
import 'package:rider_panda_app/view/authentication/login_screen.dart';
import 'package:rider_panda_app/view/authentication/signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.amber,
                    Colors.cyan,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: const Text(
            "iFood",
            style: TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontFamily: "Signatra",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: "Login",
              ),
              Tab(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                text: "Register",
              )
            ],
            unselectedLabelColor: Colors.white,
            labelColor: Colors.white,
            indicatorColor: Colors.white38,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.amber,
              Colors.cyan,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
          child: const TabBarView(
            children: [
              LoginScreen(),
              SignUpScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
