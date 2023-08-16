import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_widgets.dart';
import '../models/competitor.dart';
import '../main.dart';
import '../widgets/curve_clipper.dart';
import '../database/competitor_database.dart';
import './home_screen.dart';
import '../provider/mqtt.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var competitor = Competitor();
  var _isLoading = false;

  final _mqttHostNameController = TextEditingController();
  final _loginUserNameController = TextEditingController();
  final _loginUserPasswordController = TextEditingController();

  final _mqttFocusNode = FocusNode();
  final _loginUserNameFocusNode = FocusNode();
  final _loginUserPasswordFocusNode = FocusNode();

  bool goodConnection = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  StreamSubscription<ConnectivityResult>? subscription;

  static Future<dynamic> showCustomDialog(
      BuildContext context, String message) async {
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: Text(message,
                  style: const TextStyle(
                    color: MyApp.appSecondaryColor2,
                    // letterSpacing: 1.5,
                    fontSize: 18.0,
                  )),
              actions: [
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay')),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState == null || !(_formKey.currentState!.validate())) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<MqttProvider>(context, listen: false)
          .initializeMqttClient(competitor);
    } catch (error) {
      const errorMessage = 'Failed, check the internet connection later';

      return showCustomDialog(context, errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
  }

  var init = true;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (init) {
      subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        setState(() {
          _connectionStatus = result;
        });
      });
      // print(_connectionStatus);
      init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _mqttHostNameController.text =
        '53d10eeb011b442b82d0c35279be0429.s1.eu.hivemq.cloud';
    _loginUserNameController.text = 'Vincent';
    _loginUserPasswordController.text = '0726493355';
    final deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!(_connectionStatus == ConnectivityResult.none))
                SizedBox(
                  height: deviceHeight,
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: deviceHeight * 0.4,
                                child: ClipPath(
                                  clipper: CurveClipper(),
                                  child: const Image(
                                    image:
                                        AssetImage(MyApp.appBackgroundImgUrl),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Divider(),
                              InputField(
                                key: const ValueKey('mqttHost'),
                                controller: _mqttHostNameController,
                                hintText: 'Cluster URL',
                                icon: Icons.link,
                                obscureText: false,
                                focusNode: _mqttFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_loginUserNameFocusNode),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      !value.contains('.s1.eu.hivemq.cloud')) {
                                    return 'Please enter a valid Cluster URL';
                                  }
                                  const txtLimit = 51;
                                  if (value.length != txtLimit) {
                                    if (value.length > txtLimit) {
                                      return '${value.length - txtLimit} less characters';
                                    }
                                    return '${txtLimit - value.length} more characters';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  competitor.clusterUrl =
                                      _mqttHostNameController.text;
                                },
                              ),
                              InputField(
                                key: const ValueKey('username'),
                                controller: _loginUserNameController,
                                hintText: 'Registered Name',
                                icon: Icons.person,
                                obscureText: false,
                                focusNode: _loginUserNameFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_loginUserPasswordFocusNode),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  var allMembers = <String>[];
                                  for (var element in dataBase) {
                                    var nom = element.keys.first.trim();
                                    allMembers.add(nom);
                                  }
                                  if (!allMembers.contains(
                                      _loginUserNameController.text)) {
                                    return 'User is not in the database';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  competitor.name =
                                      _loginUserNameController.text.trim();
                                },
                              ),
                              InputField(
                                key: const ValueKey('password'),
                                controller: _loginUserPasswordController,
                                hintText: 'Password',
                                icon: Icons.lock,
                                obscureText: true,
                                keyboard: TextInputType.number,
                                focusNode: _loginUserPasswordFocusNode,
                                autoCorrect: false,
                                enableSuggestions: false,
                                textCapitalization: TextCapitalization.none,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(null),
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid password.';
                                  }

                                  if (value.length != 10 ||
                                      int.tryParse(_loginUserPasswordController
                                              .text) ==
                                          null) {
                                    return 'Invalid phone number';
                                  }

                                  // todo Lock with password
                                  // if (!dataBase.contains({
                                  //   _loginUserNameController.text:
                                  //       _loginUserPasswordController.text
                                  // })) {
                                  //   print({
                                  //     _loginUserNameController.text:
                                  //         _loginUserPasswordController.text
                                  //   });
                                  //   return 'Invalid password';
                                  // }
                                  return null;
                                },
                                onSaved: (value) {
                                  competitor.phoneNumber = int.parse(
                                      _loginUserPasswordController.text);
                                },
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: FractionalOffset.center,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  60),
                                              backgroundColor:
                                                  MyApp.appPrimaryColor,
                                              padding: const EdgeInsets.all(10),
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0))),
                                          onPressed: _submit,
                                          child: const Text('Login')))),
                            ]),
                      ),
                    ],
                  ),
                ),
              if (_isLoading || _connectionStatus == ConnectivityResult.none)
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        MyApp.appPrimaryColor.withOpacity(0.3),
                        MyApp.appSecondaryColor.withOpacity(0.2),
                        MyApp.appSecondaryColor2.withOpacity(0.2),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: _connectionStatus == ConnectivityResult.none
                      ? const Center(
                          child: Icon(
                            Icons.signal_wifi_connected_no_internet_4_sharp,
                            size: 100.0,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              if (_isLoading)
                LoadingFadingLine.circle(
                  borderColor: MyApp.appSecondaryColor,
                  borderSize: 2.0,
                  size: 40.0,
                  backgroundColor: MyApp.appPrimaryColor,
                  duration: const Duration(milliseconds: 500),
                )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    subscription?.cancel();
    _mqttFocusNode.dispose();
    _loginUserNameFocusNode.dispose();
    _loginUserPasswordFocusNode.dispose();

    _mqttHostNameController.dispose();
    _loginUserNameController.dispose();
    _loginUserPasswordController.dispose();
  }
}
