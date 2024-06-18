part of 'settings_bloc.dart';

@immutable
class SettingsState implements Equatable {
  final RegistrationState registrationState;
  final String login;
  final String password;
  final String pushToken;
  final bool isRingtoneEnabled;
  final bool isDetectCallLocationEnabled;
  final String? sdkVersionDescriprion;

  const SettingsState({
    required this.registrationState,
    required this.login,
    required this.password,
    required this.pushToken,
    required this.isRingtoneEnabled,
    required this.isDetectCallLocationEnabled,
    this.sdkVersionDescriprion,
  });

  SettingsState.copy({
    required SettingsState copied,
    RegistrationState? registrationState,
    String? login,
    String? password,
    String? pushToken,
    bool? isRingtoneEnabled,
    bool? isDetectCallLocationEnabled,
    String? sdkVersionDescriprion,
  }) :
      registrationState = registrationState ?? copied.registrationState,
      login = login ?? copied.login,
      password = password ?? copied.password,
      pushToken = pushToken ?? copied.pushToken,
      isRingtoneEnabled = isRingtoneEnabled ?? copied.isRingtoneEnabled,
      isDetectCallLocationEnabled = isDetectCallLocationEnabled ?? copied.isDetectCallLocationEnabled,
      sdkVersionDescriprion = sdkVersionDescriprion ?? copied.sdkVersionDescriprion;

  const SettingsState.initial(
      this.login, this.password,
      {
        this.registrationState = RegistrationState.notRegistered,
        this.pushToken = "",
        this.sdkVersionDescriprion = "",
        this.isRingtoneEnabled = false,
        this.isDetectCallLocationEnabled = true,
      });

  @override
  List<Object?> get props => [
    registrationState,
    pushToken
  ];

  @override
  bool? get stringify => true;
}

