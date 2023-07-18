
import 'qualifier.dart';

class IndexKey {
  IndexKey(this.runtimeType, this.qualifier);

  final Type runtimeType;
  final Qualifier? qualifier;

  @override
  String toString() {
    if (null != qualifier) {
      return '$runtimeType::$qualifier';
    } else {
      return runtimeType.toString();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndexKey &&
          runtimeType == other.runtimeType &&
          qualifier == other.qualifier;

  @override
  int get hashCode => runtimeType.hashCode ^ qualifier.hashCode;
}