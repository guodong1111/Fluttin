import 'dart:collection';

import 'definition.dart';
import 'fluttin.dart';
import 'module.dart';
import 'qualifier.dart';
import 'scope.dart';
import 'scope_definition.dart';

class ScopeRegistry {
  ScopeRegistry(this._fluttin);

  final Fluttin _fluttin;
  Map<dynamic, ScopeDefinition> scopeDefinitions =
      HashMap<String, ScopeDefinition>();

  Map<String, Scope> _scopes = HashMap<String, Scope>();

  ScopeDefinition? _rootScopeDefinition;

  Scope? _rootScope;

  Scope get rootScope => _rootScope!;

  void loadModules(Iterable<Module> modules) {
    modules.forEach(loadModule);
  }

  void loadModule(Module module) {
    declareScopeDefinitions(module.scopes);
    declareBeanDefinitions(module.definitions);
  }

  void declareScopeDefinitions(List<Qualifier> scopes) {
    scopes.forEach(createScopeDefinition);
  }

  void declareBeanDefinitions(Set<BeanDefinition> definitions) {
    definitions.forEach(declareDefinition);
  }

  void createScopeDefinition(Qualifier qualifier) {
    final ScopeDefinition def = ScopeDefinition(qualifier);
    if (scopeDefinitions[qualifier.value] == null) {
      scopeDefinitions[qualifier.value] = def;
    }
  }

  void declareDefinition(BeanDefinition bean) {
    final ScopeDefinition? scopeDef =
        scopeDefinitions[bean.scopeQualifier.value];
    scopeDef?.save(bean);
    _scopes.values
        .where((scope) => scope.scopeDefinition == scopeDef)
        .forEach((scope) {
      scope.loadDefinition(bean);
    });
  }

  void createRootScopeDefinition() {
    if (_rootScopeDefinition == null) {
      ScopeDefinition scopeDefinition = ScopeDefinition.rootDefinition();
      scopeDefinitions[ScopeDefinition.ROOT_SCOPE_QUALIFIER.value] =
          scopeDefinition;
      _rootScopeDefinition = scopeDefinition;
    }
  }

  void createRootScope() {
    if (_rootScope == null) {
      _rootScope = createScope(
          ScopeDefinition.ROOT_SCOPE_ID, ScopeDefinition.ROOT_SCOPE_QUALIFIER);
    }
  }

  Scope createScope(String scopeId, Qualifier qualifier, {dynamic source}) {
    if (_scopes.containsKey(scopeId)) {
      throw Exception("Scope with id '$scopeId' is already created");
    }

    ScopeDefinition? scopeDefinition = scopeDefinitions[qualifier.value];
    if (scopeDefinition != null) {
      Scope createdScope =
          createScopeByDefinition(scopeId, scopeDefinition, source: source);
      _scopes[scopeId] = createdScope;
      return createdScope;
    } else {
      throw Exception(
          'No Scope Definition found for qualifer \'${qualifier.value}\'');
    }
  }

  Scope createScopeByDefinition(String scopeId, ScopeDefinition scopeDefinition,
      {dynamic source}) {
    Scope scope = Scope(_fluttin, scopeId, scopeDefinition, source: source);
    List<Scope> links = <Scope>[];
    if (null != _rootScope) {
      links.add(_rootScope!);
    }
    scope.create(links);
    return scope;
  }

  void unloadModules(List<Module> modules) {
    modules.forEach(unloadModule);
  }

  void unloadModule(Module module) {
    for (BeanDefinition bean in module.definitions) {
      ScopeDefinition? scopeDefinition =
          scopeDefinitions[bean.scopeQualifier.value];
      scopeDefinition?.unloadDefinition(bean);
      _scopes.values.where((element) {
        return element.scopeDefinition.qualifier == scopeDefinition?.qualifier;
      }).forEach((element) {
        element.dropInstance(bean);
      });
    }
  }

  void deleteScope(Scope scope) {
    _scopes.remove(scope.scopeId);
  }
}
