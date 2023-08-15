import 'package:flutter/material.dart';

import 'package:iotclass/login_screen.dart';
import 'package:iotclass/mqtt.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appBackgroundImgUrl = 'assets/images/1.png';
  static const String appName = 'IOT APP';
  static const Color appPrimaryColor = Color(0xFF1e3d59);
  static const Color appSecondaryColor = Color(0xFFff6e40);
  static const Color appSecondaryColor2 = Color(0xFF000000);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MqttProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:ColorScheme.fromSwatch(primarySwatch:Colors.deepOrange),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}