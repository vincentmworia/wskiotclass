import 'package:flutter/material.dart';
import 'package:iotclass/mqtt.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  var loadStart = false;
  var loadStop = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cons) {
      final width = cons.maxWidth;
      final height = cons.maxHeight;
      return Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.brown,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Consumer<MqttProvider>(
                builder: (context, mqttVal, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width / 3, 60),
                            backgroundColor: MyApp.appPrimaryColor,
                            padding: const EdgeInsets.all(10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onPressed:loadStart?null: () async {
                          setState(() {
                            loadStart=true;
                          });
                          mqttVal.publishMsg(
                              'dekut/wsk/training/data/start', 'true');
                          await Future.delayed(const Duration(seconds: 1));
                          mqttVal.publishMsg(
                              'dekut/wsk/training/data/start', 'false');
                          setState(() {
                            loadStart=true;
                          });
                        },
                        child: const Text('START')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width / 3, 60),
                            backgroundColor: MyApp.appSecondaryColor,
                            padding: const EdgeInsets.all(10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onPressed:loadStop?null: () async {
                          setState(() {
                            loadStop=true;
                          });
                          mqttVal.publishMsg(
                              'dekut/wsk/training/data/stop', 'true');
                          await Future.delayed(const Duration(seconds: 1));
                          mqttVal.publishMsg(
                              'dekut/wsk/training/data/stop', 'false');
                          setState(() {
                            loadStop=false;
                          });
                        },
                        child: const Text('STOP')),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
