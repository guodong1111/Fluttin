import 'dart:collection';

import 'definition.dart';
import 'module.dart';
import 'qualifier.dart';
import 'scope.dart';
import 'scope_registry.dart';

class Fluttin {
  Fluttin() {
    scopeRegistry = ScopeRegistry(this);
  }

  late ScopeRegistry scopeRegistry;

  Set<Module> _modules = HashSet<Module>();

  Scope get rootScope => scopeRegistry.rootScope;

  T get<T>(Qualifier? qualifier, ParametersDefinition? parameters) {
    return scopeRegistry.rootScope
        .get(qualifier: qualifier, parameters: parameters);
  }

  Scope createScope(String scopeId, Qualifier qualifier, {dynamic source}) {
    return scopeRegistry.createScope(scopeId, qualifier, source: source);
  }

  void loadModules(List<Module> modules) {
    _modules.addAll(modules);
    scopeRegistry.loadModules(modules);
  }

  void unloadModules(List<Module> modules) {
    scopeRegistry.unloadModules(modules);
    _modules.removeAll(modules);
  }

  void close() {
    _modules.clear();
  }
}
