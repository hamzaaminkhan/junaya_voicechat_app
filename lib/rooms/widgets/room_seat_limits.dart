class RoomSeatLimits {
  static const int min = 1;

  static const int defaultCount = 15;

  static const int max = 25;

  const RoomSeatLimits._();

  static int normalize(int? value) {
    final count =
        value ?? defaultCount;

    return count.clamp(
      min,
      max,
    );
  }
}