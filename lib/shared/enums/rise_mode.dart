

enum RiseMode {
  none(1),
  truco(3),
  six(6),
  nine(9),
  twelve(12);

  final int value;


  const RiseMode(this.value);

  RiseMode get next {
    switch (this) {
      case RiseMode.none:
        return RiseMode.truco;
      case RiseMode.truco:
        return RiseMode.six;
      case RiseMode.six:
        return RiseMode.nine;
      case RiseMode.nine:
        return RiseMode.twelve;
      case RiseMode.twelve:
        return RiseMode.none;
    }
  }
}
