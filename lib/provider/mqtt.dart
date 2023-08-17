import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../database/private_data.dart';
import '../database/mqtt_topics.dart';
import '../models/competitor.dart';

enum ConnectionStatus {
  disconnected,
  connected,
}

class MqttProvider with ChangeNotifier {
  late MqttServerClient _mqttClient;

  MqttServerClient get mqttClient => _mqttClient;

  String? get disconnectTopic => _devicesClient;

  String get disconnectMessage => "Disconnected-$_loginTime";

  var _connStatus = ConnectionStatus.disconnected;

  ConnectionStatus get connectionStatus => _connStatus;

  var power = false;

  var sensorState = false;

  num setPoint = 0;
  num waterLevel = 0;
  num dischargeValveValue = 0.0;

  final platform = Platform.isAndroid
      ? "Android"
      : Platform.isWindows
          ? "Windows"
          : Platform.isFuchsia
              ? "Fuchsia"
              : Platform.isIOS
                  ? "IOS"
                  : Platform.isLinux
                      ? "Linux"
                      : "Unknown Operating System";
  String? _deviceId;
  String? _devicesClient;
  String? _loginTime;

  Future<ConnectionStatus> initializeMqttClient(Competitor competitor) async {
    _deviceId = '${competitor.name}/${competitor.phoneNumber}';
    _devicesClient = 'dekut/wsk/training/devices/$platform/$_deviceId';

    _loginTime = DateTime.now().toIso8601String();
    final connMessage = MqttConnectMessage()
      ..authenticateAs(competitor.name,
          '${competitor.name}${competitor.phoneNumber.toString()}')
      ..withWillTopic(_devicesClient!)
      ..withWillMessage('DisconnectedHard-$_loginTime')
      ..withWillRetain()
      ..startClean()
      ..withWillQos(MqttQos.exactlyOnce);
    _mqttClient = MqttServerClient.withPort(
        competitor.clusterUrl!,
        // competitor.clusterUrl!,
        'flutter_client/$_devicesClient/${DateTime.now().toIso8601String()}',
        mqttPort)
      ..secure = true
      ..securityContext = SecurityContext.defaultContext
      ..keepAlivePeriod = 30
      ..securityContext = SecurityContext.defaultContext
      ..connectionMessage = connMessage
      ..onConnected = onConnected
      ..onDisconnected = onDisconnected;

    try {
      await _mqttClient.connect();

      _mqttClient.subscribe(
          "dekut/wsk/training/data-from-plc/#", MqttQos.exactlyOnce);
      _mqttClient.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        final topic = c[0].topic;
        var message = json.decode(
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message));

        if (topic == powerLedTopic) {
          power = message as bool;
          notifyListeners();
        }
        if (topic == sensorStateTopic) {
          sensorState = message as bool;
          notifyListeners();
        }
        if (topic == dischargeValveTopic) {
          dischargeValveValue = message as double;
          notifyListeners();
        }
        if (topic == setPointTopic) {
          setPoint = message;
          notifyListeners();
        }
        if (topic == waterLevelTopic) {
          waterLevel = message;

          notifyListeners();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('\n\nException: $e');
      }
      _mqttClient.disconnect();
      _connStatus = ConnectionStatus.disconnected;

      rethrow;
    }
    return _connStatus;
  }

  void refresh() {
    notifyListeners();
  }

  void publishMsg(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (kDebugMode) {
      print('Publishing message "$message" to topic $topic');
    }
    _mqttClient.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!,
        retain: true);
  }

  void onConnected() {
    _connStatus = ConnectionStatus.connected;
    publishMsg(_devicesClient!, 'Connected-$_loginTime');
  }

  void onDisconnected() {
    _connStatus = ConnectionStatus.disconnected;
    notifyListeners();
  }
}
