import 'definition.dart';
import 'qualifier.dart';

class Definitions {
  static BeanDefinition<T> createSingle<T>(Qualifier scopeQualifier,
      Qualifier? qualifier, Definition<T> definition) {
    return BeanDefinition<T>(
        scopeQualifier, T, qualifier, definition, Kind.Single);
  }

  static BeanDefinition<T> createFactory<T>(Qualifier scopeQualifier,
      Qualifier? qualifier, Definition<T> definition) {
    return BeanDefinition<T>(
        scopeQualifier, T, qualifier, definition, Kind.Factory);
  }
}
