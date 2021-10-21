import 'definition.dart';
import 'fluttin_component.dart';
import 'qualifier.dart';
import 'scope.dart';

abstract class FluttinScopeComponent extends FluttinComponent {
  FluttinScopeComponent();

  String getScopeId() => '${this}@${DateTime.now().microsecondsSinceEpoch}';

  Qualifier getScopeName() => TypeQualifier(this.runtimeType);

  Scope newScope({dynamic source}) {
    return getFluttin()
        .createScope(getScopeId(), getScopeName(), source: source);
  }

  late final Scope scope;

  void closeScope() {
    scope.close();
  }

  T inject<T>({Qualifier? qualifier, ParametersDefinition? parameters}) =>
      scope.get(qualifier: qualifier, parameters: parameters);
}
