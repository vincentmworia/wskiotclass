import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iotclass/widgets/mqtt.dart';
import 'package:provider/provider.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  var val = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MqttProvider>(
      builder: (_, mqttVal, __) => Slider(
        value: val,
        onChanged: (value) {
          // todo Making the operation asynchronous
          Future.delayed(Duration.zero).then((value) => mqttVal.publishMsg(
              'dekut/wsk/training/data/water-level', json.encode(value * 100)));
          setState(() {
            val = value;
          });
        },
      ),
    );
  }
}
