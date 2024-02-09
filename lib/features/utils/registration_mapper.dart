import 'package:exolve_voice_sdk/communicator/registration/registration_event.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';

class RegistrationMapper {
  static RegistrationState fromRegistrationEventToState({required RegistrationEvent event}) {
    if (event is RegistrationRegisteredEvent) {
      return RegistrationState.registered;
    }

    if (event is RegistrationRegisteringEvent) {
      return RegistrationState.registering;
    }

    if (event is RegistrationNotRegisteredEvent) {
      return RegistrationState.notRegistered;
    }

    if (event is RegistrationOfflineEvent) {
      return RegistrationState.offline;
    }

    if (event is RegistrationNoConnectionEvent) {
      return RegistrationState.noConnection;
    }

    if (event is RegistrationErrorEvent) {
      return RegistrationState.error;
    }

    throw Exception("Unknown registration event: $event");
  }
}
