part of 'settings_bloc.dart';

@immutable
class SettingsState implements Equatable {
  final RegistrationState registrationState;
  final String login;
  final String password;
  final String pushToken;

  const SettingsState({
    required this.registrationState,
    required this.login,
    required this.password,
    required this.pushToken
  });

  SettingsState.copy({
    required SettingsState copied,
    RegistrationState? registrationState,
    String? login,
    String? password,
    String? pushToken
  }) :
      registrationState = registrationState ?? copied.registrationState,
      login = login ?? copied.login,
      password = password ?? copied.password,
      pushToken = pushToken ?? copied.pushToken;

  const SettingsState.initial(
      this.login, this.password,
      {
        this.registrationState = RegistrationState.notRegistered,
        this.pushToken = ""
      });

  @override
  List<Object?> get props => [
    registrationState,
    pushToken
  ];

  @override
  bool? get stringify => true;
}

