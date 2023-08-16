import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/mqtt.dart';

class SetPointView extends StatelessWidget {
  const SetPointView(this.cons, {super.key});

  final BoxConstraints cons;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Consumer<MqttProvider>(
          builder: (_, mqttVal, __) {
            var setPoint =mqttVal.setPoint;
            return Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.all(cons.maxWidth * 0.075),
              decoration: BoxDecoration(
                  color: MyApp.appPrimaryColor.withOpacity(0.99),
                  border: Border.all(color: MyApp.appPrimaryColor, width: 4),
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Text(
                  '$setPoint %',
                  style: const TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ),
            );
          },
        ),
        const Text('Set point',
            style: TextStyle(color: MyApp.appPrimaryColor, fontSize: 20)),
      ],
    );
  }
}
