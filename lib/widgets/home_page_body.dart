import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iotclass/widgets/mqtt.dart';
import 'package:iotclass/widgets/push_button_view.dart';
import 'package:iotclass/widgets/slider_view.dart';
import 'package:iotclass/widgets/water_level_view.dart';
import 'package:provider/provider.dart';

import 'custom_slider.dart';
import '../main.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, cons) => Column(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(child: WaterLevelView(cons)),
                                  const VerticalDivider(),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Consumer<MqttProvider>(
                                          builder: (_, mqttVal, __) {
                                            var setPoint = 0.0;
                                            return Container(
                                              margin: EdgeInsets.all(
                                                  cons.maxWidth * 0.075),
                                              decoration: BoxDecoration(
                                                  color: MyApp.appSecondaryColor
                                                      .withOpacity(0.1),
                                                  border: Border.all(
                                                      color:
                                                          MyApp.appPrimaryColor,
                                                      width: 4),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Text(
                                                '$setPoint %',
                                                style: TextStyle(
                                                    color: setPoint < 10
                                                        ? Colors.cyanAccent
                                                        : setPoint >= 10 &&
                                                                setPoint < 60
                                                            ? Colors.white
                                                            : MyApp
                                                                .appSecondaryColor,
                                                    fontSize: 25.0),
                                              ),
                                            );
                                          },
                                        ),
                                        const Text('Set point',
                                            style: TextStyle(
                                                color: MyApp.appPrimaryColor,
                                                fontSize: 22)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: PushButtonView(),
                ),
                const Expanded(
                  flex: 2,
                  child: SliderView(),
                ),
              ],
            ));
  }
}
