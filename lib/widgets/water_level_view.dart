import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/mqtt.dart';

class WaterLevelView extends StatelessWidget {
  const WaterLevelView(
    this.cons, {
    super.key,
  });

  final BoxConstraints cons;
  static num waterLevel=0.0;
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
                topLeft: Radius.circular(cons.maxWidth * 0.015),
                topRight: Radius.circular(cons.maxWidth * 0.015),
                bottomLeft: Radius.circular(cons.maxWidth * 0.035),
                bottomRight: Radius.circular(cons.maxWidth * 0.035),
              ),
            ),
          );

      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          waterContainer(con.maxHeight, MyApp.appPrimaryColor.withOpacity(0.2)),
          Consumer<MqttProvider>(

            builder: (_, mqttVal, __) {
                waterLevel =mqttVal.waterLevel;

              return Stack(
                alignment: Alignment.center,
                children: [
                  waterContainer(con.maxHeight * waterLevel / 100,Colors.cyanAccent.withOpacity(0.8)),
                  if(waterLevel>5)
                  Text(
                    '$waterLevel %',
                    style: TextStyle(
                        color:  waterLevel >= 10 && waterLevel < 60
                                ? Colors.white
                                : MyApp.appPrimaryColor,
                        fontSize: 25.0),
                  )
                ],
              );
            },
          ),
          const Text('Water Level',
              style: TextStyle(color: MyApp.appPrimaryColor, fontSize: 20))
        ],
      );
    });
  }
}
