import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import 'mqtt.dart';

class WaterLevelView extends StatelessWidget {
  const WaterLevelView(
    this.cons, {
    super.key,
  });

  final BoxConstraints cons;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, con) {
      Widget waterContainer(double height, Color clr) => Container(
            margin: EdgeInsets.all(cons.maxWidth * 0.075),
            height: height,
            // todo get the value from mqtt
            decoration: BoxDecoration(
              color: clr,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(cons.maxWidth * 0.075),
                topRight: Radius.circular(cons.maxWidth * 0.075),
                bottomLeft: Radius.circular(cons.maxWidth * 0.05),
                bottomRight: Radius.circular(cons.maxWidth * 0.05),
              ),
            ),
          );
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          waterContainer(con.maxHeight, MyApp.appPrimaryColor.withOpacity(0.2)),
          Consumer<MqttProvider>(

            builder: (_, mqttVal, __) {
              var waterLevel = 0.0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  waterContainer(con.maxHeight * waterLevel / 100, MyApp.appPrimaryColor),
                  Text(
                    '$waterLevel %',
                    style: TextStyle(
                        color: waterLevel < 10
                            ? Colors.cyanAccent
                            : waterLevel >= 10 && waterLevel < 60
                                ? Colors.white
                                : MyApp.appSecondaryColor,
                        fontSize: 25.0),
                  )
                ],
              );
            },
          ),
          const Text('Water Level',
              style: TextStyle(color: MyApp.appPrimaryColor, fontSize: 22))
        ],
      );
    });
  }
}
