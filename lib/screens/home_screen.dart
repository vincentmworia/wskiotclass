import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iotclass/screens/login_screen.dart';

import '../main.dart';
import '../widgets/home_page_body.dart';
import '../widgets/logout_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectivityResult? _connectionStatus;

  var init = true;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (init) {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        setState(() {
          _connectionStatus = result;
        });
      });
      init = false;
    }
  }

  StreamSubscription<ConnectivityResult>? subscription;

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus == ConnectivityResult.none) {
      Future.delayed(Duration.zero).then((value) =>
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginScreen())));
    }
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyApp.appPrimaryColor,
        title: const Text(MyApp.appName),
        leading: const LogoutButton(),
      ),
      body: const HomePageBody(),
    ));
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
  }
}
