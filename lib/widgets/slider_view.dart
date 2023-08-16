import 'package:flutter/material.dart';

import '../main.dart';
import './custom_slider.dart';

class SliderView extends StatelessWidget {
  const SliderView({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Divider(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Discharge valve slider',
              style: TextStyle(
                color: MyApp.appPrimaryColor,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: CustomSlider(),
          ),
          Divider(),
        ],
      );
}
