import 'package:bonfire/bonfire.dart';
import 'package:lesson_flutter_bonfire_with_websocket/ally/controllers/ally_player_controller.dart';

import '../abilities/slash_ability_sprite.dart';
import '../main.dart';
import '../player/knight_sprite.dart';

class AllyPlayer extends SimpleAlly
    with ObjectCollision, UseStateController<AllyPlayerController> {
  final String id;

  AllyPlayer({
    required this.id,
    required Vector2 position,
    required Direction direction,
  }) : super(
          initDirection: direction,
          position: position,
          size: Vector2(
            tileSize,
            tileSize,
          ),
          animation: SimpleDirectionAnimation(
            idleRight: KnightSprite.idleRight,
            runRight: KnightSprite.runRight,
            idleLeft: KnightSprite.idleLeft,
            runLeft: KnightSprite.runLeft,
          ),
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(20, 20),
            align: Vector2(6, 15),
          ),
        ],
      ),
    );
  }

  executeAttack(Direction direction) {
    if (hasGameRef && !gameRef.camera.isMoving) {
      simpleAttackMelee(
        damage: 10,
        size: Vector2(40, 40),
        interval: 10,
        animationRight: SlashAbilitySprite.right,
        animationDown: SlashAbilitySprite.down,
        animationLeft: SlashAbilitySprite.left,
        animationUp: SlashAbilitySprite.up,
        direction: direction,
      );
    }
  }
}
