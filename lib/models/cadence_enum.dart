enum Cadence {
  once,
  hour,
  day,
  week,
  month,
  year
}

extension CadenceExtension on Cadence {
  String get label {
    switch (this) {
      case Cadence.once:
        return 'Once';
      case Cadence.hour:
        return 'Hourly';
      case Cadence.day:
        return 'Daily';
      case Cadence.week:
        return 'Weekly';
      case Cadence.month:
        return 'Monthly';
      case Cadence.year:
        return 'Yearly';
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
