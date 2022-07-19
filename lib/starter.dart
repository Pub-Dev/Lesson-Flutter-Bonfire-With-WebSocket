import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter_bonfire_with_websocket/ally/ally_player.dart';
import 'package:lesson_flutter_bonfire_with_websocket/entities/message.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/knight_player.dart';
import 'package:uuid/uuid.dart';

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
    messageService.add(ActionMessage.allyInvocation, _invockAllyOnline);
    messageService.add(ActionMessage.myInvocation, _sendMyInvokation);
    super.initState();
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
      //showCollisionArea: true,
      components: const [
        //GoblinEnemy(position: Vector2(tileSize * 10, tileSize * 10)),
      ],
      onReady: (gameRef) {
        messageService.send(
          Message(
            idPlayer: id,
            action: ActionMessage.allyInvocation,
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

  void _invockAllyOnline(Message message) {
    final ally = AllyPlayer(
      id: message.idPlayer,
      position: message.position,
      direction: message.direction.toDirection(),
    );
    gameController.addGameComponent(ally);
    messageService.send(
      Message(
        idPlayer: id,
        action: ActionMessage.myInvocation,
        direction:
            DirectionMessage.direction(gameController.player!.lastDirection),
        position: Vector2(
          gameController.player!.position.x,
          gameController.player!.position.y,
        ),
      ),
    );
  }

  void _sendMyInvokation(Message message) {
    final ally = AllyPlayer(
      id: message.idPlayer,
      position: message.position,
      direction: message.direction.toDirection(),
    );
    gameController.addGameComponent(ally);
  }
}
