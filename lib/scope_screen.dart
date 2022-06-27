import 'package:flutter/material.dart';

import 'fluttin_scope_component.dart';

class ScreenScope extends FluttinScopeComponent {

}

mixin ScreenScopeMixin<T extends StatefulWidget> on State<T> {
  final ScreenScope _screenScope = ScreenScope();

  @override
  void dispose() {
    super.dispose();
    _screenScope.closeScope();
  }
}
