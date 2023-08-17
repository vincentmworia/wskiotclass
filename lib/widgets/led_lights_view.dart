import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/mqtt.dart';

class LedLightsView extends StatelessWidget {
  const LedLightsView(this.cons, {super.key});

  final BoxConstraints cons;

  @override
  Widget build(BuildContext context) {
    Widget container(bool condition, String title) => Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.all(cons.maxWidth * 0.05),
                decoration: BoxDecoration(
                  border: Border.all(color: MyApp.appPrimaryColor,width: 2),
                    color:
                         MyApp.appPrimaryColor.withOpacity(condition ?0.8:0.3)  ,
                    shape: BoxShape.circle),
              ),
                Text(title,
                  style: const TextStyle(color: MyApp.appPrimaryColor, fontSize: 20))
            ],
          ),
        );
    return Consumer<MqttProvider>(
      builder: (_, mqttVal, __) => Column(
        children: [
          container(mqttVal.power, 'Power'),
          container(mqttVal.sensorState, 'Sensor state'),
        ],
      ),
    );
  }
}
