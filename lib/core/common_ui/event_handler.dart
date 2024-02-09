import 'package:flutter_bloc/flutter_bloc.dart';

interface class ScreenEventHandler<T> {
  Emitter<T>? emitter;

  setEmitter(Emitter<T> emitter) { this.emitter = emitter; }

  handle() {
    // TODO: implement invoke
    throw UnimplementedError();
  }
}