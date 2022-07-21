import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/controllers/player_controller.dart';
import 'package:lesson_flutter_bonfire_with_websocket/player/knight_sprite.dart';

import '../abilities/slash_ability_sprite.dart';
import '../main.dart';

class KnightPlayer extends SimplePlayer
    with
        ObjectCollision,
        JoystickListener,
        UseStateController<PlayerController> {
  final String id;

  KnightPlayer({
    required this.id,
  }) : super(
          position: Vector2(
            tileSize * 5,
            tileSize * 5,
          ),
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

  @override
  void render(Canvas canvas) {
    drawDefaultLifeBar(
      canvas,
      borderWidth: 1,
      height: 2,
      align: const Offset(0, 0),
    );
    super.render(canvas);
  }

  @override
  void joystickAction(JoystickActionEvent event) {
    if (hasGameRef && !gameRef.camera.isMoving) {
      if (event.event == ActionEvent.DOWN && event.id == 1) {
        controller.onAttack();
        simpleAttackMelee(
          damage: 10,
          size: Vector2(40, 40),
          animationRight: SlashAbilitySprite.right,
          animationDown: SlashAbilitySprite.down,
          animationLeft: SlashAbilitySprite.left,
          animationUp: SlashAbilitySprite.up,
          direction: lastDirection,
        );
      }
    }
  }

  @override
  void die() async {
    removeFromParent();
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
    super.die();
  }

  @override
  void onMove(double speed, Direction direction, double angle) {
    if (hasController) {
      controller.onMove(speed, direction);
    }
    super.onMove(speed, direction, angle);
  }

  @override
  void idle() {
    if (hasController) {
      controller.idleAction(lastDirection);
    }
    super.idle();
  }
}
