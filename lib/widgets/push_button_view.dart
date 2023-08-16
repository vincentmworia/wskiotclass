import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'mqtt.dart';

class PushButtonView extends StatefulWidget {
  const PushButtonView({super.key});

  @override
  State<PushButtonView> createState() => _PushButtonViewState();
}

class _PushButtonViewState extends State<PushButtonView> {

  var loadStart = false;
  var loadStop = false;
  @override
  Widget build(BuildContext context)=>Consumer<MqttProvider>(
    builder: (context, mqttVal, child) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: Size(
                    MediaQuery.of(context).size.width / 3, 60),
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
                fixedSize: Size(
                    MediaQuery.of(context).size.width / 3, 60),
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
  );
}
