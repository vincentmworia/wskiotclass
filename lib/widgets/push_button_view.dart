import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/mqtt.dart';
import '../database/private_data.dart';

class PushButtonView extends StatefulWidget {
  const PushButtonView({super.key});

  @override
  State<PushButtonView> createState() => _PushButtonViewState();
}

class _PushButtonViewState extends State<PushButtonView> {
  var loadStart = false;
  var loadStop = false;

  Widget buttons(
          {required MqttProvider mqttVal,
          required String title,
          required Color bgColor,
          required String mqttTopic}) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width / 3, 60),
              backgroundColor: bgColor,
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
                  mqttVal.publishMsg(mqttTopic, json.encode(true));
                  await Future.delayed(const Duration(milliseconds: 500));
                  mqttVal.publishMsg(mqttTopic, json.encode(false));
                  setState(() {
                    loadStart = false;
                  });
                },
          child: Text(title));

  @override
  Widget build(BuildContext context) => Consumer<MqttProvider>(
        builder: (context, mqttVal, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buttons(
                mqttTopic: startButtonTopic,
                bgColor: MyApp.appPrimaryColor,
                mqttVal: mqttVal,
                title: 'START'),
            buttons(
                mqttTopic: stopButtonTopic,
                bgColor: MyApp.appSecondaryColor,
                mqttVal: mqttVal,
                title: 'STOP'),
          ],
        ),
      );
}
