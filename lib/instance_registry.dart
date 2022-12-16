import 'definition.dart';
import 'instance_context.dart';
import 'instance_factory.dart';
import 'scope.dart';

class InstanceRegistry {
  InstanceRegistry(this._scope);

  final Scope _scope;

  final Map<String, InstanceFactory> _instances = <String, InstanceFactory>{};

  void create(Set<BeanDefinition> definitions) {
    for (BeanDefinition definition in definitions) {
      saveDefinition(definition);
    }
  }

  T? resolveInstance<T>(String indexKey, ParametersDefinition? parameters) {
    return _instances[indexKey]?.get(defaultInstanceContext(parameters));
  }

  InstanceContext defaultInstanceContext(ParametersDefinition? parameters) =>
      InstanceContext(_scope, parameters);

  void saveDefinition(BeanDefinition definition) {
    InstanceFactory instanceFactory = createInstanceFactory(definition);
    _saveInstance(indexKey(definition.primaryType, definition.qualifier),
        instanceFactory);
  }

  void _saveInstance(String key, InstanceFactory factory) {
    _instances[key] = factory;
  }

  InstanceFactory createInstanceFactory(BeanDefinition definition) {
    switch (definition.kind) {
      case Kind.single:
        return SingleInstanceFactory(definition);
      case Kind.factory:
        return FactoryInstanceFactory(definition);
    }
  }

  void dropDefinition(BeanDefinition definition) {
    List<String> ids = _instances.entries
        .where((element) {
          return element.value.beanDefinition == definition;
        })
        .map((e) => e.key)
        .toList();
    ids.forEach(_instances.remove);
  }

  void createDefinition(BeanDefinition definition) {
    saveDefinition(definition);
  }

  void close() {
    for (InstanceFactory factory in _instances.values) {
      factory.drop();
    }
    _instances.clear();
  }
}
