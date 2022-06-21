import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bazatlima/loginPage.dart';

void main() {
  runApp(const SplashPage());
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duracion = const Duration(seconds: 3);
    return Timer(duracion, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              (Color.fromARGB(255, 0, 0, 0)),
              (Color.fromARGB(255, 57, 62, 63)),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Center(
            child: Image.asset("assets/images/app_logo.png"),
          )
        ],
      ),
    );
  }
}
