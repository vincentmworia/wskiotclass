import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iotclass/login_screen.dart';
import 'package:iotclass/main.dart';
import 'package:iotclass/mqtt.dart';
import 'package:provider/provider.dart';

import 'custom_widgets.dart';
import 'home_page_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyApp.appPrimaryColor,
        title: const Text(MyApp.appName),
        actions: [
          IconButton(
              onPressed: () async {
                return await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          content: const Text('Logout?',
                              style: TextStyle(
                                color: MyApp.appSecondaryColor2,
                                fontSize: 18.0,
                              )),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('No')),
                                ),
                                Center(
                                  child: Consumer<MqttProvider>(
                                    builder: (ctx, mqttVal, child) =>
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            onPressed: () {
                                              mqttVal.mqttClient.disconnect();
                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const LoginScreen()));
                                            },
                                            child: const Text('Yes')),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ));
              },
              icon: const Icon(
                Icons.logout,
                size: 30,
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: const HomePageBody(),
    ));
  }
}
