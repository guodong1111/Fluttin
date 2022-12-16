
import 'dart:collection';

import 'definition.dart';
import 'qualifier.dart';

class ScopeDefinition {
  ScopeDefinition(this.qualifier);

  static const String ROOT_SCOPE_ID = '-Root-';
  static const Qualifier ROOT_SCOPE_QUALIFIER = StringQualifier(ROOT_SCOPE_ID);

  static ScopeDefinition rootDefinition() =>
      ScopeDefinition(ROOT_SCOPE_QUALIFIER);

  final Qualifier qualifier;
  final Set<BeanDefinition> definitions = HashSet<BeanDefinition>();

  void save(BeanDefinition beanDefinition) {
    definitions.add(beanDefinition);
  }

  void remove(BeanDefinition beanDefinition) {
    definitions.remove(beanDefinition);
  }

  void unloadDefinition(BeanDefinition beanDefinition) {
    definitions.remove(beanDefinition);
  }

  int size() => definitions.length;

  @override
  String toString() {
    return 'ScopeDefinition{qualifier: $qualifier}';
  }
}
