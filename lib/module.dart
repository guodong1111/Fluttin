import 'dart:collection';

import 'definition.dart';
import 'definitions.dart';
import 'qualifier.dart';
import 'scope_definition.dart';
import 'scope_dsl.dart';

typedef ModuleDeclaration = Function(Module);

Module module(ModuleDeclaration moduleDeclaration) {
  Module module = Module();
  moduleDeclaration(module);
  return module;
}

class Module {
  final Qualifier rootScope = ScopeDefinition.ROOT_SCOPE_QUALIFIER;

  Set<BeanDefinition> definitions = HashSet<BeanDefinition>();
  List<Qualifier> scopes = <Qualifier>[];

  void single<T>(Definition<T> definition, {Qualifier? qualifier}) {
    final BeanDefinition<T> def =
        Definitions.createSingle(rootScope, qualifier, definition);
    definitions.add(def);
  }

  void factory<T>(Definition<T> definition, {Qualifier? qualifier}) {
    final BeanDefinition<T> def =
        Definitions.createFactory(rootScope, qualifier, definition);
    definitions.add(def);
  }

  void scope<T>(Function(ScopeDSL) scopeSet) {
    Qualifier qualifier = TypeQualifier(T);
    ScopeDSL scopeDSL = ScopeDSL(qualifier, definitions);
    scopeSet(scopeDSL);
    scopes.add(qualifier);
  }
}
