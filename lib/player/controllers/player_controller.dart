import 'package:bonfire/bonfire.dart';
import 'package:lesson_flutter_bonfire_with_websocket/entities/message.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/knight_player.dart';
import 'package:lesson_flutter_bonfire_with_websocket/services/message_service.dart';

class PlayerController extends StateController<KnightPlayer> {
  final MessageService messageService;

  PlayerController({
    required this.messageService,
  });

  @override
  void update(double dt, KnightPlayer component) {}

  onAttack() {
    messageService.send(Message(
      idPlayer: component!.id,
      action: ActionMessage.attack,
      direction: DirectionMessage.direction(component!.lastDirection),
    ));
  }

  onMove(double speed, Direction direction) {
    if (speed > 0) {
      messageService.send(
        Message(
          idPlayer: component!.id,
          action: ActionMessage.move,
          direction: DirectionMessage.direction(direction),
          position: Vector2(component!.x, component!.y),
        ),
      );
    } else {
      idleAction(direction);
    }
  }

  void idleAction(Direction direction) {
    messageService.send(
      Message(
        idPlayer: component!.id,
        action: ActionMessage.idle,
        direction: DirectionMessage.direction(direction),
        position: Vector2(component!.x, component!.y),
      ),
    );
  }
}
