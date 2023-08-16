import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/home_page_body.dart';
import '../widgets/logout_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
}
