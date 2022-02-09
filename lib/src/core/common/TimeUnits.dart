enum TimeUnits {
  YEARS,
  MONTHS,
  WEEKS,
  DAYS,
  HOURS,
  MINUTES,
  SECONDS,
  MILLISECONDS,
  MICROSECONDS,
  TICKS,
}

extension TimeUnitsExtension on TimeUnits {
  String stringify() {
    switch(this) {
      case TimeUnits.YEARS:
        return "YEARS";
      case TimeUnits.MONTHS:
        return "MONTHS";
      case TimeUnits.WEEKS:
        return "WEEKS";
      case TimeUnits.DAYS:
        return "DAYS";
      case TimeUnits.HOURS:
        return "HOURS";
      case TimeUnits.MINUTES:
        return "MINUTES";
      case TimeUnits.SECONDS:
        return "SECONDS";
      case TimeUnits.MILLISECONDS:
        return "MILLISECONDS";
      case TimeUnits.MICROSECONDS:
        return "MICROSECONDS";
      case TimeUnits.TICKS:
        return "TICKS";
    }
  }
}