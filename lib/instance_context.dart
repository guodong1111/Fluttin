import 'definition.dart';
import 'scope.dart';

class InstanceContext {
  InstanceContext(this.scope, ParametersDefinition? parameters)
      : parameters =
            (null != parameters) ? parameters() : DefinitionParameters();

  final Scope scope;

  final DefinitionParameters parameters;
}
