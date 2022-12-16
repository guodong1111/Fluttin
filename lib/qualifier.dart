abstract class Qualifier {
  const Qualifier();

  abstract final String value;
}

class StringQualifier extends Qualifier {
  const StringQualifier(this.value);

  @override
  final String value;

  @override
  String toString() {
    return 'StringQualifier{value: $value}';
  }
}

class TypeQualifier extends Qualifier {
  TypeQualifier(Type type) : value = type.toString();

  @override
  final String value;

  @override
  String toString() {
    return 'q:$value';
  }
}
