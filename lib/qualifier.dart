abstract class Qualifier<T> {
  const Qualifier();

  abstract final T _value;
}

class StringQualifier extends Qualifier<String> {
  const StringQualifier(this._value);

  @override
  final String _value;

  @override
  String toString() {
    return 'StringQualifier{value: $_value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StringQualifier &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

class TypeQualifier extends Qualifier<Type> {
  const TypeQualifier(this._value);

  @override
  final Type _value;

  @override
  String toString() {
    return 'TypeQualifier{value: $_value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeQualifier &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

class EnumQualifier extends Qualifier<Enum> {
  const EnumQualifier(this._value);

  @override
  final Enum _value;

  @override
  String toString() {
    return 'EnumQualifier{value: $_value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnumQualifier &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;
}

