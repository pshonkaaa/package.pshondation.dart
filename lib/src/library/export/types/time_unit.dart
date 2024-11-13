enum TimeUnit {
  YEAR,
  MONTH,
  WEEK,
  DAY,
  HOUR,
  MINUTE,
  SECOND,
  MILLISECOND,
  MICROSECOND,
}

extension TimeUnitsExtension on TimeUnit {
  String stringify() {
    switch(this) {
      case TimeUnit.YEAR:
        return "YEARS";
      case TimeUnit.MONTH:
        return "MONTHS";
      case TimeUnit.WEEK:
        return "WEEKS";
      case TimeUnit.DAY:
        return "DAYS";
      case TimeUnit.HOUR:
        return "HOURS";
      case TimeUnit.MINUTE:
        return "MINUTES";
      case TimeUnit.SECOND:
        return "SECONDS";
      case TimeUnit.MILLISECOND:
        return "MILLISECONDS";
      case TimeUnit.MICROSECOND:
        return "MICROSECONDS";
    }
  }
}