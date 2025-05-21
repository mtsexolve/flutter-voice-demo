import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool isRingtoneEnabled;
  final bool isDetectLocationEnabled;
  const Settings({required this.isRingtoneEnabled, required this.isDetectLocationEnabled});

  Settings.fromJson(Map<String, dynamic> json) :
    isRingtoneEnabled = json['isRingtoneEnabled'],
    isDetectLocationEnabled = json['isDetectLocationEnabled'];

  @override
  List<Object> get props => [
    isRingtoneEnabled,
    isDetectLocationEnabled,
  ];

  Map<String, dynamic> toJson() => {
    'isRingtoneEnabled': isRingtoneEnabled,
    'isDetectLocationEnabled': isDetectLocationEnabled,
  };
}