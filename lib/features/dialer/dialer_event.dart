part of 'dialer_bloc.dart';


abstract class DialerEvent {}

class DialerButtonPressedEvent extends DialerEvent {
  final String digit;
  DialerButtonPressedEvent({required this.digit});
}


class ContactPickerClickedEvent extends DialerEvent {
  ContactPickerClickedEvent();

  Emitter<DialerState>? emitter;

  setEmitter(Emitter<DialerState> emitter) {
    this.emitter = emitter;
  }

  handle() async {
    log("dialer_event: ContactPickerClickedEvent:");
    final status =  await Permission.contacts.request();
    if(status.isGranted){
      log("dialer_event: ContactPickerClickedEvent: contact permissions is granted");
      Contact? contact = await FlutterNativeContactPicker().selectContact();
      String contactNumber = contact?.phoneNumbers?.first.replaceAll(RegExp(r'[^0-9]'),'') ?? "";
      emitter!(DialerState(enteredNumber: contactNumber,));
    }
  }
}


class CreateCallEvent extends DialerEvent {}

class RemoveDigitEvent extends DialerEvent {}

class RemoveAllDigitsEvent extends DialerEvent {}

class TransferCallEvent extends DialerEvent {
  final String callId;
  TransferCallEvent({required this.callId});
}

