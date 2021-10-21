
import 'context.dart';
import 'definition.dart';
import 'fluttin.dart';
import 'qualifier.dart';

class FluttinComponent {
  Fluttin getFluttin() => GlobalContext.getInstance().get();

  T inject<T>({Qualifier? qualifier, ParametersDefinition? parameters}) => getFluttin().get(qualifier, parameters);
}

