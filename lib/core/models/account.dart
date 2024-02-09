import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String? login;
  final String? password;
  const Account({required this.login, required this.password});

  Account.fromJson(Map<String, dynamic> json) :
    login = json['login'],
    password = json['password'];

  @override
  List<Object?> get props => [
    login,
    password,
  ];

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
  };
}

