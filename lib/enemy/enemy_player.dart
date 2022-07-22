import 'package:bonfire/bonfire.dart';

import '../abilities/slash_ability_sprite.dart';
import '../main.dart';
import '../player/knight_sprite.dart';
import 'controllers/enemy_player_controller.dart';

class EnemyPlayer extends SimpleEnemy
    with ObjectCollision, UseStateController<EnemyPlayerController> {
  final String id;

  EnemyPlayer({
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
        withPush: true,
      );
    }
  }

  @override
  void die() async {
    final sprite = await KnightSprite.die;
    gameRef.add(
      GameDecoration.withSprite(
        sprite: sprite.getSprite(),
        position: Vector2(
          position.x,
          position.y,
        ),
        size: Vector2.all(30),
      ),
    );
    removeFromParent();
    super.die();
  }
}
