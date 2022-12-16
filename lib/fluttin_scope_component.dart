import 'context.dart';
import 'definition.dart';
import 'fluttin.dart';
import 'qualifier.dart';
import 'scope.dart';

Fluttin _getFluttin() => GlobalContext.getInstance().get();

List<Scope> _scopePools = [];

abstract class FluttinScopeComponent {
  late final Scope scope;

  FluttinScopeComponent() {
    scope = _newScope();
    _scopePools.add(scope);
  }

  String getScopeId() =>
      '$runtimeType@${DateTime.now().microsecondsSinceEpoch}';

  Qualifier getScopeName() => TypeQualifier(this.runtimeType);

  Scope _newScope({dynamic source}) {
    return _getFluttin()
        .createScope(getScopeId(), getScopeName(), source: source);
  }

  void closeScope() {
    _scopePools.remove(scope);
    scope.close();
  }
}

T create<T>(FluttinScopeComponent component,
    {Qualifier? qualifier, ParametersDefinition? parameters}) {
  return component.scope.get(qualifier: qualifier, parameters: parameters);
}

T inject<T>({Qualifier? qualifier, ParametersDefinition? parameters}) {
  for (Scope scope in _scopePools.reversed) {
    try {
      return scope.get(qualifier: qualifier, parameters: parameters);
    } catch (e) {
      //try to find an instance in the next scope
    }
  }

  return _getFluttin()
      .rootScope
      .get(qualifier: qualifier, parameters: parameters);
}
