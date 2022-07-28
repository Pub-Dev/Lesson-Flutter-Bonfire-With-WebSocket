import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter_bonfire_with_websocket/entities/message.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/knight_player.dart';
import 'package:uuid/uuid.dart';

import 'enemy/enemy_player.dart';
import 'main.dart';
import 'services/message_service.dart';

class Starter extends StatefulWidget {
  const Starter({Key? key}) : super(key: key);

  @override
  State<Starter> createState() => _StarterState();
}

class _StarterState extends State<Starter> {
  late final GameController gameController;
  late final MessageService messageService;
  late final String id;

  @override
  void initState() {
    id = const Uuid().v1();
    gameController = GameController();
    messageService = BonfireInjector.instance.get();
    messageService.init();
    messageService.onListen(ActionMessage.enemyInvocation, _addEnemy);
    messageService.onListen(
        ActionMessage.previouslyEnemyConnected, _addEnemyBeforeYourLogin);
    super.initState();
  }

  @override
  void dispose() {
    messageService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BonfireTiledWidget(
      gameController: gameController,
      map: TiledWorldMap(
        'maps/map.json',
        forceTileSize: const Size(tileSize, tileSize),
      ),
      player: KnightPlayer(id: id),
      joystick: Joystick(
        directional: JoystickDirectional(),
        keyboardConfig: KeyboardConfig(
          keyboardDirectionalType: KeyboardDirectionalType.wasdAndArrows,
        ),
        actions: [
          JoystickAction(
            actionId: 1,
            color: Colors.orange,
            margin: const EdgeInsets.all(40),
          ),
        ],
      ),
      components: const [],
      onReady: (gameRef) {
        messageService.send(
          Message(
            idPlayer: id,
            action: ActionMessage.enemyInvocation,
            direction: DirectionMessage.right,
            position: Vector2(
              gameRef.player!.position.x,
              gameRef.player!.position.y,
            ),
          ),
        );
      },
    );
  }

  void _addEnemy(Message message) {
    final enemy = EnemyPlayer(
      id: message.idPlayer,
      position: message.position!,
      direction: message.direction.toDirection(),
    );
    gameController.addGameComponent(enemy);
    messageService.send(
      Message(
        idPlayer: id,
        action: ActionMessage.previouslyEnemyConnected,
        direction: DirectionMessage.direction(
          gameController.player!.lastDirection,
        ),
        position: gameController.player!.position,
      ),
    );
  }

  void _addEnemyBeforeYourLogin(Message message) {
    final hasEnemy = gameController.gameRef
        .componentsByType<EnemyPlayer>()
        .any((element) => element.id == message.idPlayer);
    if (!hasEnemy) {
      final enemy = EnemyPlayer(
        id: message.idPlayer,
        position: message.position!,
        direction: message.direction.toDirection(),
      );
      gameController.addGameComponent(enemy);
    }
  }
}
