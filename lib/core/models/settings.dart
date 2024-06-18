import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool isRingtoneEnabled;
  final bool isDetectCallLocationEnabled;
  const Settings({required this.isRingtoneEnabled, required this.isDetectCallLocationEnabled});

  Settings.fromJson(Map<String, dynamic> json) :
    isRingtoneEnabled = json['isRingtoneEnabled'],
    isDetectCallLocationEnabled = json['isDetectCallLocationEnabled'];

  @override
  List<Object> get props => [
    isRingtoneEnabled,
    isDetectCallLocationEnabled,
  ];

  Map<String, dynamic> toJson() => {
    'isRingtoneEnabled': isRingtoneEnabled,
    'isDetectCallLocationEnabled': isDetectCallLocationEnabled,
  };
}