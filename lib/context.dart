import 'fluttin.dart';
import 'global_context.dart';

abstract class FluttinContext {
  Fluttin get();

  Fluttin? getOrNull();

  void register(FluttinApplication application);

  void stop();
}

class GlobalContext extends FluttinContext {
  GlobalContext._();

  static final GlobalContext _instance = GlobalContext._();

  factory GlobalContext.getInstance() => _instance;

  Fluttin? _fluttin;

  void startFluttin(FluttinAppDeclaration declaration) {
    FluttinApplication application = FluttinApplication.init();
    register(application);
    declaration(application);
  }

  @override
  Fluttin get() {
    return _fluttin!;
  }

  @override
  Fluttin? getOrNull() {
    return _fluttin;
  }

  @override
  void register(FluttinApplication application) {
    _fluttin = application.fluttin;
  }

  @override
  void stop() {
    _fluttin?.close();
    _fluttin = null;
  }
}

void startFluttin(FluttinAppDeclaration declaration) {
  GlobalContext.getInstance().startFluttin(declaration);
}
