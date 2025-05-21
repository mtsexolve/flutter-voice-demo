import 'package:flutter_voice_example/core/telecom/telecom_manager.dart';

import 'dialer_bloc.dart';

class DialerBlocManager {
  final Map<String, DialerBloc> _blocks = {};
  DialerBloc get(String id) {
    return _blocks.putIfAbsent(id, () => DialerBloc(telecomManager: TelecomManager()));
  }
  void dispose() {
    for(final bloc in _blocks.values) {
      bloc.close();
    }
    _blocks.clear();
  }
}