import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

import 'enemy/controllers/goblin_generator_controller.dart';
import 'services/message_service.dart';
import 'services/websocket_service.dart';
import 'starter.dart';

const double tileSize = 32;

void main() {
  BonfireInjector.instance.put((i) => GoblinGeneratorController());

  final websocket = WebsocketService();
  BonfireInjector.instance.put((i) => websocket);
  BonfireInjector.instance.put((i) => MessageService(
        websocket: BonfireInjector.instance.get(),
      ));

  runApp(
    const MaterialApp(
      home: Starter(),
    ),
  );
}
