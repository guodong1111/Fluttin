import 'package:collection/collection.dart';
import 'qualifier.dart';
import 'scope.dart';

typedef Definition<T> = T Function(Scope, DefinitionParameters);
typedef ParametersDefinition = DefinitionParameters Function();

//定義工廠模式的藍圖
class BeanDefinition<T> {
  BeanDefinition(this.scopeQualifier, this.primaryType, this.qualifier,
      this.definition, this.kind);

  final Qualifier scopeQualifier;
  final Type primaryType;
  final Qualifier? qualifier;
  final Definition<T> definition;
  final Kind kind;
}

String indexKey(Type runtimeType, Qualifier? qualifier) {
  if (null != qualifier) {
    return '$runtimeType::${qualifier.value}';
  } else {
    return runtimeType.toString();
  }
}

//提供外部帶參數的地方
class DefinitionParameters {
  DefinitionParameters({List<dynamic>? values})
      : _values = values ?? <dynamic>[];

  final List<dynamic> _values;

  operator [](int index) => get(index);

  T get<T>(int index) {
    return _values[index] as T;
  }

  T? getOrNull<T>() {
    try {
      return _values.singleWhere((element) => element is T);
    } catch (e) {
      return null;
    }
  }

  void set<T>(int index, T t) {
    _values[index] = t;
  }

  void add<T>(T t) {
    _values.add(t);
  }

  void insert<T>(int index, T t) {
    _values.insert(index, t);
  }

  int size() {
    return _values.length;
  }

  bool isEmpty() {
    return _values.isEmpty;
  }

  bool isNotEmpty() {
    return _values.isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    Function eq = const ListEquality().equals;
    return identical(this, other) ||
        other is DefinitionParameters &&
            runtimeType == other.runtimeType &&
            eq(_values, other._values);
  }

  @override
  int get hashCode => const ListEquality().hash(_values);
}

enum Kind { single, factory }
