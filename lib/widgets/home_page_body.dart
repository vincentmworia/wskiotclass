import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iotclass/widgets/mqtt.dart';
import 'package:provider/provider.dart';

import 'custom_slider.dart';
import '../main.dart';

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
            flex: 8,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
                const Divider()
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Consumer<MqttProvider>(
              builder: (context, mqttVal, child) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      onPressed: loadStart
                          ? null
                          : () async {
                              setState(() {
                                loadStart = true;
                              });
                              mqttVal.publishMsg(
                                  'dekut/wsk/training/data-to-plc/start',
                                  json.encode(true));
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              mqttVal.publishMsg(
                                  'dekut/wsk/training/data-to-plc/start',
                                  json.encode(false));
                              setState(() {
                                loadStart = false;
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
                      onPressed: loadStop
                          ? null
                          : () async {
                              setState(() {
                                loadStop = false;
                              });
                              mqttVal.publishMsg(
                                  'dekut/wsk/training/data-to-plc/stop',
                                  json.encode(true));
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              mqttVal.publishMsg(
                                  'dekut/wsk/training/data-to-plc/stop',
                                  json.encode(false));
                              setState(() {
                                loadStop = false;
                              });
                            },
                      child: const Text('STOP')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Divider(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Discharge valve slider',
                    style: TextStyle(
                      color: MyApp.appPrimaryColor,
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: CustomSlider(),
                ),
                Divider(),
              ],
            ),
          ),
        ],
      );
    });
  }
}
