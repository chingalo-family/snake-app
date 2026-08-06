enum Direction { up, down, left, right }

extension DirectionHelpers on Direction {
  bool get isHorizontal => this == Direction.left || this == Direction.right;

  bool get isVertical => this == Direction.up || this == Direction.down;

  bool isSameAxisAs(Direction other) => isHorizontal == other.isHorizontal;

  bool isOppositeOf(Direction other) {
    return (this == Direction.up && other == Direction.down) ||
        (this == Direction.down && other == Direction.up) ||
        (this == Direction.left && other == Direction.right) ||
        (this == Direction.right && other == Direction.left);
  }

  Direction get opposite => switch (this) {
        Direction.up => Direction.down,
        Direction.down => Direction.up,
        Direction.left => Direction.right,
        Direction.right => Direction.left,
      };
}
