abstract class IPrettyPrint {
  PrettyPrint toPrettyPrint();  
}

abstract class PrettyPrint {
  factory PrettyPrint({
    required String title,
    EPrettyPrintType type,
    int spacesPerTab,
  }) = _PrettyPrint;

  PrettyPrint add(String key, Object? value);

  PrettyPrint append(PrettyPrint pp);
  
  String generate();
}

enum EPrettyPrintType {
  array,
  map,
  object,
}

class _PrettyPrint implements PrettyPrint {
  final String title;
  final EPrettyPrintType type;
  final int spacesPerTab;
  final List<MapEntry<String, Object?>> entries = [];
  _PrettyPrint({
    required this.title,
    this.type = EPrettyPrintType.object,
    this.spacesPerTab = 2,
  });

  @override
  PrettyPrint add(String key, Object? value) {
    if(value is List) {
      final pp = new PrettyPrint(title: "", type: EPrettyPrintType.array);
      final list = value;
      for(int i = 0; i < list.length; i++)
        pp.add(i.toString(), list[i]);
      entries.add(new MapEntry(key, pp));
    } else if(value is Map) {
      final pp = new PrettyPrint(title: "", type: EPrettyPrintType.map);
      final map = value;
      for(final entry in map.entries)
        pp.add(entry.key.toString(), entry.value);
      entries.add(new MapEntry(key, pp));
    } else entries.add(new MapEntry(key, value));
    return this;
  }
  
  @override
  PrettyPrint append(covariant _PrettyPrint pp) {
    entries.addAll(pp.entries);
    return this;
  }

  @override
  String generate([int index = 1]) {
    final sb = new StringBuffer();
    String tab = _incTabulation(index, spacesPerTab);
    switch(type) {
      case EPrettyPrintType.array:
        sb.write("[");
        if(entries.isNotEmpty) {
          sb.write("\n");
          for(final entry in entries) {
            final key = entry.key;
            final value = _object2String(entry.value, index + 1);
            sb.writeln('$tab"$key": "$value",');
          } sb.write("$tab]");
        } else sb.write("]");
        break;

      case EPrettyPrintType.map:
        sb.write("{");
        if(entries.isNotEmpty) {
          sb.write("\n");
          for(final entry in entries) {
            final key = entry.key;
            final value = _object2String(entry.value, index + 1);
            sb.writeln('$tab"$key": $value,');
          } sb.write("$tab}");
        } else sb.write("}");
        break;

      case EPrettyPrintType.object:
        sb.write("$title {");
        if(entries.isNotEmpty) {
          sb.write("\n");
          for(final entry in entries) {
            final key = entry.key;
            final value = _object2String(entry.value, index + 1);
            sb.writeln("$tab$key = $value,");
          } sb.write("$tab}");
        } else sb.write("}");
        break;
    } return sb.toString();
  }




  static String _object2String(Object? value, int tabulation) {
    String msg;
    if(value == null)
      msg = "null";
    else if(value is IPrettyPrint)
      msg = (value.toPrettyPrint() as _PrettyPrint).generate(tabulation);
    else if(value is PrettyPrint)
      msg = (value as _PrettyPrint).generate(tabulation);
    else if(value is String)
      msg = '"$value"';
    else msg = value.toString();
    return msg;
  }

  static String _incTabulation(int index, int spacesPerTab) {
    String msg = "";
    for(int i = 0; i < index * spacesPerTab; i++)
      msg += " ";
    return msg;
  }

}