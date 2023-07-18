abstract class Qualifier<T> {
  const Qualifier();

  abstract final T value;
}

class StringQualifier extends Qualifier<String> {
  const StringQualifier(this.value);

  @override
  final String value;

  @override
  String toString() {
    return 'StringQualifier{value: $value}';
  }
}

class TypeQualifier extends Qualifier<Type> {
  const TypeQualifier(this.value);

  @override
  final Type value;

  @override
  String toString() {
    return 'q:$value';
  }
}

class EnumQualifier extends Qualifier<Enum> {
  const EnumQualifier(this.value);

  @override
  final Enum value;

  @override
  String toString() {
    return 'q:$value';
  }
}

