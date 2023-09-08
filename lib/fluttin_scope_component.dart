import 'context.dart';
import 'definition.dart';
import 'fluttin.dart';
import 'qualifier.dart';
import 'scope.dart';

Fluttin _getFluttin() => GlobalContext.getInstance().get();

abstract class FluttinScopeComponent {
  late final Scope scope;

  FluttinScopeComponent() {
    scope = _newScope();
  }

  String getScopeId() =>
      '$runtimeType@${DateTime.now().microsecondsSinceEpoch}';

  Qualifier getScopeName() => TypeQualifier(this.runtimeType);

  Scope _newScope({dynamic source}) {
    return _getFluttin()
        .createScope(getScopeId(), getScopeName(), source: source);
  }

  void closeScope() {
    scope.close();
  }
}

T create<T>(FluttinScopeComponent component,
    {Qualifier? qualifier, ParametersDefinition? parameters}) {
  return component.scope.get(qualifier: qualifier, parameters: parameters);
}

T inject<T>({Qualifier? qualifier, ParametersDefinition? parameters}) {
  return _getFluttin()
      .rootScope
      .get(qualifier: qualifier, parameters: parameters);
}
