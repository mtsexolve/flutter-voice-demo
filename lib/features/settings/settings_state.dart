part of 'settings_bloc.dart';

@immutable
class SettingsState implements Equatable {
  final RegistrationState registrationState;
  final String login;
  final String password;
  final String pushToken;
  final String? sdkVersionDescriprion;

  const SettingsState({
    required this.registrationState,
    required this.login,
    required this.password,
    required this.pushToken,
    this.sdkVersionDescriprion,
  });

  SettingsState.copy({
    required SettingsState copied,
    RegistrationState? registrationState,
    String? login,
    String? password,
    String? pushToken,
    String? sdkVersionDescriprion,
  }) :
      registrationState = registrationState ?? copied.registrationState,
      login = login ?? copied.login,
      password = password ?? copied.password,
      pushToken = pushToken ?? copied.pushToken,
      sdkVersionDescriprion = sdkVersionDescriprion ?? copied.sdkVersionDescriprion;

  const SettingsState.initial(
      this.login, this.password,
      {
        this.registrationState = RegistrationState.notRegistered,
        this.pushToken = "",
        this.sdkVersionDescriprion = ""
      });

  @override
  List<Object?> get props => [
    registrationState,
    pushToken
  ];

  @override
  bool? get stringify => true;
}

