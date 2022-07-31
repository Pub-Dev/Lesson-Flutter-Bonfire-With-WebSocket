import 'package:bonfire/bonfire.dart';
import 'package:lesson_flutter_bonfire_with_websocket/enemy/enemy_player.dart';
import 'package:lesson_flutter_bonfire_with_websocket/entities/message.dart';
import 'package:lesson_flutter_bonfire_with_websocket/services/message_service.dart';

import '../../abilities/slash_ability_sprite.dart';

class EnemyPlayerController extends StateController<EnemyPlayer> {
  final MessageService messageService;
  bool isIdle = true;
  Direction direction = Direction.right;

  EnemyPlayerController({
    required this.messageService,
  });

  @override
  void update(double dt, EnemyPlayer component) {
    moveLocal();
  }

  moveLocal() {
    if (isIdle) {
      component!.idle();
      return;
    }
    double speed = component!.speed;
    double speedDiagonal = (speed * Movement.REDUCTION_SPEED_DIAGONAL);
    switch (direction) {
      case Direction.left:
        component!.moveLeft(speed);
        break;
      case Direction.downLeft:
        component!.moveDownLeft(speedDiagonal, speedDiagonal);
        break;
      case Direction.upLeft:
        component!.moveUpLeft(speedDiagonal, speedDiagonal);
        break;
      case Direction.right:
        component!.moveRight(speed);
        break;
      case Direction.downRight:
        component!.moveDownRight(speedDiagonal, speedDiagonal);
        break;
      case Direction.upRight:
        component!.moveUpRight(speedDiagonal, speedDiagonal);
        break;
      case Direction.down:
        component!.moveDown(speed);
        break;
      case Direction.up:
        component!.moveUp(speed);
        break;
      default:
        component!.idle();
        break;
    }
  }

  @override
  void onReady(EnemyPlayer component) {
    messageService.onListen(ActionMessage.move, moveServer);
    messageService.onListen(ActionMessage.idle, idleServer);
    messageService.onListen(ActionMessage.attack, attackServer);
    messageService.onListen(ActionMessage.disconnect, disconnectedEnemyPlayer);
    super.onReady(component);
  }

  void attackServer(Message message) {
    if (message.idPlayer == component!.id) {
      component!.simpleAttackMelee(
        damage: 10,
        size: Vector2(40, 40),
        interval: 10,
        animationRight: SlashAbilitySprite.right,
        animationDown: SlashAbilitySprite.down,
        animationLeft: SlashAbilitySprite.left,
        animationUp: SlashAbilitySprite.up,
        direction: direction,
        withPush: true,
      );
    }
  }

  void idleServer(Message message) {
    if (message.idPlayer == component!.id) {
      isIdle = true;
      component!.lastDirection = message.direction.toDirection();
      direction = message.direction.toDirection();
    }
  }

  void moveServer(Message message) {
    if (message.idPlayer == component!.id) {
      isIdle = false;
      component!.position = message.position!;
      direction = message.direction.toDirection();
    }
  }

  void disconnectedEnemyPlayer(Message message) {
    if (message.idPlayer == component!.id) {
      component!.die();
    }
  }
}
