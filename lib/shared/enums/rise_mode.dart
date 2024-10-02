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
    static RiseMode fromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'none':
        return RiseMode.none;
      case 'truco':
        return RiseMode.truco;
      case 'six':
        return RiseMode.six;
      case 'nine':
        return RiseMode.nine;
      case 'twelve':
        return RiseMode.twelve;
      default:
        throw ArgumentError('Valor inválido para RiseMode: $mode');
    }
  }

  RiseMode get previous {
    switch (this) {
      case RiseMode.none:
        return RiseMode.none;
      case RiseMode.truco:
        return RiseMode.none;
      case RiseMode.six:
        return RiseMode.truco;
      case RiseMode.nine:
        return RiseMode.six;
      case RiseMode.twelve:
        return RiseMode.nine;
    }
  }
}
