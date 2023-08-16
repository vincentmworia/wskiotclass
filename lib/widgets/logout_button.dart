import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../screens/login_screen.dart';
import '../provider/mqtt.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
        ));
  }
}
