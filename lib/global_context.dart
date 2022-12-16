
import 'fluttin.dart';
import 'module.dart';

typedef FluttinAppDeclaration = Function(FluttinApplication application);

class FluttinApplication {
  FluttinApplication();

  factory FluttinApplication.init() {
    FluttinApplication app = FluttinApplication();
    app.init();
    return app;
  }

  final Fluttin fluttin = Fluttin();

  void init() {
    fluttin.scopeRegistry.createRootScopeDefinition();
    fluttin.scopeRegistry.createRootScope();
  }

  void modules(List<Module> modules) {
    _loadModules(modules);
  }

  void _loadModules(List<Module> modules) {
    fluttin.loadModules(modules);
  }

}