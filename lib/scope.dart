import 'definition.dart';
import 'fluttin.dart';
import 'instance_registry.dart';
import 'qualifier.dart';
import 'scope_definition.dart';

class Scope {
  Scope(this._fluttin, this.scopeId, this.scopeDefinition, {this.source}) {
    _instanceRegistry = InstanceRegistry(this);
  }

  final Fluttin _fluttin;

  final String scopeId;
  final ScopeDefinition scopeDefinition;

  dynamic source;
  final List<Scope> _linkedScope = <Scope>[];
  late final InstanceRegistry _instanceRegistry;
  DefinitionParameters? _parameters;

  void create(List<Scope> links) {
    _instanceRegistry.create(scopeDefinition.definitions);
    _linkedScope.addAll(links);
  }

  Scope? getPreviousScope() {
    if (_linkedScope.isEmpty) {
      return null;
    } else {
      return _linkedScope.last;
    }
  }

  bool isRootScope() {
    return ScopeDefinition.ROOT_SCOPE_ID == scopeId;
  }

  T get<T>({Qualifier? qualifier, ParametersDefinition? parameters}) {
    return _get(T, qualifier, parameters);
  }

  T? getOrNull<T>({Qualifier? qualifier, ParametersDefinition? parameters}) {
    try {
      return _get(T, qualifier, parameters);
    } catch (e) {
      return null;
    }
  }

  T _get<T>(Type runtimeType, Qualifier? qualifier,
      ParametersDefinition? parameters) {
    return resolveInstance(qualifier, runtimeType, parameters);
  }

  T getSource<T>() {
    return source as T;
  }

  T resolveInstance<T>(Qualifier? qualifier, Type runtimeType,
      ParametersDefinition? parameters) {
    final String key = indexKey(runtimeType, qualifier);

    T? instance = _instanceRegistry.resolveInstance(key, parameters) ??
        getFromSource() ?? _parameters?.getOrNull() ??
        findInOtherScope(qualifier, parameters);
    if (null == instance) {
      throw Exception('no instance found for $key on scope ${toString()}');
    }
    return instance;
  }

  T? getFromSource<T>() {
    try {
      return source as T;
    } catch (e) {
      return null;
    }
  }

  T? findInOtherScope<T>(Qualifier? qualifier,
      ParametersDefinition? parameters) {
    T? instance;
    for (Scope scope in _linkedScope) {
      instance = scope.getOrNull<T>(
          qualifier: qualifier,
          parameters: parameters
      );
      if (instance != null) break;
    }
    return instance;
  }

  void dropInstance(BeanDefinition beanDefinition) {
    _instanceRegistry.dropDefinition(beanDefinition);
  }

  void loadDefinition(BeanDefinition beanDefinition) {
    _instanceRegistry.createDefinition(beanDefinition);
  }

  void close() {
    clear();
    _fluttin.scopeRegistry.deleteScope(this);
  }

  void clear() {
    source = null;
    _instanceRegistry.close();
  }

  void addParameters(DefinitionParameters parameters) {
    _parameters = parameters;
  }

  void clearParameters() {
    _parameters = null;
  }

  @override
  String toString() {
    return 'Scope{scopeId: $scopeId}';
  }
}