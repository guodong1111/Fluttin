# Fluttin
A pragmatic lightweight dependency injection framework for Flutter developers.

## Getting Started
This is the Flutter version of koin, which is almost the same as the original koin in use.
It's just that dart's closure doesn't support receiver type, so it looks a bit complicated in this class
But the principle is the same.
For the concept of DI, please refer to the official website of koin: https://insert-koin.io/

You need to execute startFluttin at the beginning of the project.
```dart
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initFluttin();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

  Future<void> initFluttin() async {
    startFluttin((FluttinApplication application) {
      application.modules(<Module>[
        Modules.module,
        Modules.screenModule,
        Modules.serviceModule,
        Modules.dbModule,
      ]);
    });
  }
}
```

Then create modules.dart in libs/
```dart

class Modules {
  static Module module = module((Module module) {
    module.factory((Scope scope, DefinitionParameters parameters) =>
        MyGameRepository(
            scope.get(), scope.get(), scope.get(), scope.get(), scope.get()));
  });

  static Module screenModule = module((Module module) {
    module.scope<ScreenScope>((scopeSet) {});
  });

  static Module serviceModule = module((Module module) {
    module.single((Scope scope, DefinitionParameters parameters) =>
        ServiceManager.instance);
    module.single((Scope scope, DefinitionParameters parameters) =>
        scope.get<ServiceManager>().gatewayService);
  });

  static Module dbModule = module((Module module) {
    module.single(
        (Scope scope, DefinitionParameters parameters) => DBUtils.appDatabase);
    module.single((Scope scope, DefinitionParameters parameters) =>
        scope.get<AppDatabase>().screenDao);
  });
}
```

You don’t need to pay attention to how other classes are generated in this class
```dart

class MyGameRepository {
  MyGameRepository(this._appInfoDao, this._downloadPackageDao,
          this._taskInfoDao, this._userAppDao, this._appVirtualDao);

  final AppInfoDao _appInfoDao;
  final DownloadPackageDao _downloadPackageDao;
  final DownloadTaskDao _taskInfoDao;
  final UserAppDao _userAppDao;
  final AppVirtualDao _appVirtualDao;
  
}
```


## The following is a simple instruction:

* If you want to use it, you can directly use inject() to generate it

```dart
class _XXState extends State<XXWidget> {
  MyGameRepository _myGameRepository = inject();
    @override
    Widget build(BuildContext context) {
        return Scaffold();
    }
}
```


* If you want to write a module, there are several ways to provide it:
  + factory: Each inject() generates a new instance.
  + single:  Only the first inject() will be a new instance, and the instance generated for the 
    first time will be used later. It is equivalent to the concept of singleton.
  + scoped:  When the scope condition is met, only the first inject() will be a new instance, 
    and it will be reused later.
    for example:
    scope=UserScope, which means that when the user is logged in, the same instance will be output from inject(),
    When the user logs out and then logs in again, the new instance will be tried again.
    It can be understood as a singleton in user login.

* If other classes will be used in the class I want to generate 
  + scope.get()
    ```dart
      module.factory((Scope scope, DefinitionParameters parameters) =>
        MessageScreenCubit(scope.get(), scope.get());
    ```

* If I want to dynamically pass in parameters
  + DefinitionParameters
    ```dart
    messageScreenCubit = inject(parameters: () {
      return DefinitionParameters(values: [
        widget.conversation,
        widget.conversationId,
        widget.targetUserId,
      ]);
    });
    ```
    ```dart
    module.factory((Scope scope, DefinitionParameters parameters) {
      return MessageScreenCubit(conversation: parameters[0],
              conversationId: parameters[1],
              userId: parameters[2],
              );
    });
    ```


* If I want to provide different implementations for an interface in the module
  + qualifier
    ```dart
    class _XXState extends State<XXWidget> {
      Animal animal = inject(qualifier: StringQualifier('dog'));

      @override
      Widget build(BuildContext context) {
          return Scaffold();
        }
      }
    ```

    ```dart
    module.factory<Animal>(
      (Scope scope, DefinitionParameters parameters) => Dog(),
      qualifier: StringQualifier('dog')
    );
    module.factory<Animal>(
      (Scope scope, DefinitionParameters parameters) => Cat(),
      qualifier: StringQualifier('cat')
    );
    ```
