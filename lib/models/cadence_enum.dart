enum Cadence {
  hour,
  day,
  week,
  month,
}

extension CadenceExtension on Cadence {
  String get label {
    switch (this) {
      case Cadence.hour:
        return 'Hourly';
      case Cadence.day:
        return 'Daily';
      case Cadence.week:
        return 'Weekly';
      case Cadence.month:
        return 'Monthly';
    }
  }

  static Cadence fromString(String value) {
    return Cadence.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => Cadence.day, // default fallback
    );
  }

  String toJson() => name;

}
