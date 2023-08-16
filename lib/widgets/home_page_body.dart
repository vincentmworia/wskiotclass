import 'package:flutter/material.dart';

import './push_button_view.dart';
import './set_point_view.dart';
import './slider_view.dart';
import './water_level_view.dart';
import './led_lights_view.dart';

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
                                    child: SetPointView(cons),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: LedLightsView(cons),
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
