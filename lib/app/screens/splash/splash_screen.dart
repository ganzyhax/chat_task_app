import 'dart:async';
import 'dart:developer';

import 'package:chat_task_app/app/screens/chat/chat_screen.dart';
import 'package:chat_task_app/app/screens/login/login_screen.dart';
import 'package:chat_task_app/app/services/on_close_service.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppLifecycleObserver _appLifecycleObserver = AppLifecycleObserver();

  bool isLogged = false;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);

    _initializeState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  Future<void> _initializeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? '';

    if (userId != '') {
      isLogged = true;
    }
    await Future.delayed(Duration(seconds: 1));

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => (isLogged) ? ChatScreen() : LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(
                'Chat App',
                style: TextStyle(fontSize: 46),
              )),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator()
        ],
      ),
    ));
  }
}
