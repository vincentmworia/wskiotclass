import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/mqtt_topics.dart';
import '../main.dart';
import '../provider/mqtt.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  var val = 0.0;
  var percentage = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttProvider>(
      builder: (_, mqttVal, __) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Slider(
            value: mqttVal.dischargeValveValue / 100,
            onChanged: (value) {
              percentage = double.parse((value * 100).toStringAsFixed(1));
              Future.delayed(Duration.zero).then((value) => mqttVal.publishMsg(
                  dischargeValveTopic,
                  json.encode(percentage)));
              setState(() {
                val = value;
              });
            },
          ),
          Text(
            (mqttVal.dischargeValveValue).toString(),
            style: const TextStyle(color: MyApp.appPrimaryColor, fontSize: 16),
          )
        ],
      ),
    );
  }
}
