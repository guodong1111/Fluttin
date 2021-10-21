import 'definition.dart';
import 'instance_context.dart';

abstract class InstanceFactory<T> {
  InstanceFactory(this.beanDefinition);

  final BeanDefinition<T> beanDefinition;

  T get(InstanceContext context);

  T create(InstanceContext context) {
    DefinitionParameters parameters = context.parameters;
    context.scope.addParameters(parameters);
    T value = beanDefinition.definition(context.scope, parameters);
    context.scope.clearParameters();
    return value;
  }

  void drop() {}
}

class FactoryInstanceFactory<T> extends InstanceFactory<T> {
  FactoryInstanceFactory(BeanDefinition<T> beanDefinition)
      : super(beanDefinition);

  @override
  T get(InstanceContext context) {
    return create(context);
  }
}

class SingleInstanceFactory<T> extends InstanceFactory<T> {
  SingleInstanceFactory(BeanDefinition<T> beanDefinition)
      : super(beanDefinition);

  Map<DefinitionParameters, T> map = <DefinitionParameters, T>{};

  @override
  T get(InstanceContext context) {
    T value = map.putIfAbsent(context.parameters, () => create(context));
    return value;
  }

  @override
  void drop() {
    map.clear();
  }
}
