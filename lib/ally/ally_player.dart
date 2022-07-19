import 'package:bonfire/bonfire.dart';

import '../main.dart';
import '../player/knight_sprite.dart';

class AllyPlayer extends SimpleAlly with ObjectCollision {
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
}
