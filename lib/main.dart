import 'package:flutter/material.dart';
import 'package:iotclass/screens/home_screen.dart';

import 'package:iotclass/screens/login_screen.dart';
import 'package:iotclass/widgets/mqtt.dart';
import 'package:provider/provider.dart';

void main() {
  // todo Lock the orientation to vertical
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
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
          appBarTheme: const AppBarTheme(
            toolbarHeight: 80.0,
            backgroundColor: MyApp.appPrimaryColor,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 25.0,
              // color: MyApp.appSecondaryColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 8.0,
            ),
          ).copyWith(iconTheme: const IconThemeData(size: 30.0,color: appSecondaryColor)),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
