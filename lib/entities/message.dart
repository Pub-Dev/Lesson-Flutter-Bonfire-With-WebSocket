import 'package:bonfire/bonfire.dart';

class Message {
  Message({
    required this.idPlayer,
    required this.action,
    required this.direction,
    required this.position,
  });

  final String idPlayer;
  final String action;
  final String direction;
  final Vector2 position;

  Map<String, dynamic> toJson() {
    return {
      'id': idPlayer,
      'action': action,
      'direction': direction,
      'position': {
        'x': position.x,
        'y': position.y,
      }
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        idPlayer: json['id'],
        action: json['action'],
        direction: json['direction'],
        position: Vector2(
          double.parse(json['position']['x'].toString()),
          double.parse(json['position']['y'].toString()),
        ),
      );
}

class ActionMessage {
  static const String myInvocation = "MY_INVOCATION";
  static const String allyInvocation = "ALLY_INVOCATION";
  static const String disconnect = "DISCONNECT";
}

class DirectionMessage {
  static const String right = "RIGHT";
  static const String left = "LEFT";

  static String direction(Direction direction) {
    if (direction == Direction.right) {
      return right;
    }
    if (direction == Direction.left) {
      return left;
    }
    return right;
  }
}

extension DirectionToDirectionMessage on String {
  toDirection() {
    if (this == DirectionMessage.right) {
      return Direction.right;
    }
    if (this == DirectionMessage.left) {
      return Direction.left;
    }
    return Direction.right;
  }
}
