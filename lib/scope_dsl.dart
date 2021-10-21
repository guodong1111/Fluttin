import 'definition.dart';
import 'definitions.dart';
import 'qualifier.dart';

class ScopeDSL {
  ScopeDSL(this.scopeQualifier, this.definitions);

  final Qualifier scopeQualifier;
  final Set<BeanDefinition> definitions;

  BeanDefinition<T> scoped<T>(Definition<T> definition,
      {Qualifier? qualifier}) {
    final BeanDefinition<T> def =
        Definitions.createSingle(scopeQualifier, qualifier, definition);
    definitions.add(def);
    return def;
  }

  BeanDefinition<T> factory<T>(Definition<T> definition,
      {Qualifier? qualifier}) {
    final BeanDefinition<T> def =
        Definitions.createFactory(scopeQualifier, qualifier, definition);
    definitions.add(def);
    return def;
  }
}
