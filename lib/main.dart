import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter_bonfire_with_websocket/ally/controllers/ally_player_controller.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/controllers/player_controller.dart';

import 'enemy/controllers/goblin_generator_controller.dart';
import 'services/message_service.dart';
import 'services/websocket_service.dart';
import 'starter.dart';

const double tileSize = 32;

void main() {
  BonfireInjector.instance.put((i) => GoblinGeneratorController());

  final websocket = WebsocketService();
  BonfireInjector.instance.put((i) => websocket);
  BonfireInjector.instance.put((i) => MessageService(websocket: i.get()));
  BonfireInjector.instance.put(
    (i) => PlayerController(messageService: i.get()),
  );
  BonfireInjector.instance.put(
    (i) => AllyPlayerController(messageService: i.get()),
  );

  runApp(
    const MaterialApp(
      home: Starter(),
    ),
  );
}
