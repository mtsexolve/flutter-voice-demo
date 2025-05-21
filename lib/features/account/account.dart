import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_voice_example/features/account/account_bloc.dart';
import 'package:exolve_voice_sdk/communicator/registration/registration_state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/colors_mts.dart';
import '../../constants/strings_mts.dart';
import '../../core/common_ui/data_field.dart';

class Account extends StatelessWidget {
  const Account({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return _accountController();
  }

  Widget _accountController() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child:BlocBuilder<AccountBloc, AccountState>(
        builder : (context, state) {
          log('account: _accountController: state: $state');
          return Column(
            children: [ 
              DataField(
                text: state.login,
                label: StringsMts.accountLogin,
                hint: StringsMts.accountLoginHint,
                name: "login",
              ),
              const SizedBox(height: 24,),
              DataField(
                text: state.password,
                label: StringsMts.accountPassword,
                hint: StringsMts.accountPasswordHint,
                name: "password"
              ),
              const SizedBox(height: 24,),
              _activationControlButton(
                context: context,
                state: state.registrationState,
                activateEvent: ActivateSipAccountEvent(),
                deactivateEvent: DeactivateAccountEvent(),
              ),
              const SizedBox(height: 24,),
              _pushTokenFrame(context: context, token: state.pushToken),
              const Spacer(),
            ]
          );
        }
      )
    );
  }

  Widget _activationControlButton({required BuildContext context,
    required RegistrationState state,
    required AccountEvent activateEvent,
    required AccountEvent deactivateEvent}) {
    final isRegistered = state == RegistrationState.registered;
    final event = isRegistered ? deactivateEvent : activateEvent;
    final text = isRegistered ? StringsMts.accountDeactivate :StringsMts.accountActivate;
    return FractionallySizedBox(
      alignment: Alignment.topCenter,
      widthFactor: 0.5,
      child: Container(
        height: 50,
        child: TextButton(
          onPressed: () {
            context.read<AccountBloc>().add(event);
          },
          style: Theme.of(context).textButtonTheme.style,
          child: Text(
            text,
            style: const TextStyle(
                fontFamily: 'mtswide',
                fontWeight: FontWeight.w400,
                color: ColorsMts.white,
                fontSize: 18
            ),
          ),
        ),
      ),
    );
  }

  Widget _pushTokenFrame({required BuildContext context, required String token}) {
    return Column(
      children: [
        const Row(
          children: [
            Text(StringsMts.accountPushToken),
            Spacer()
          ]
        ),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: token));
            Fluttertoast.showToast(
                msg: StringsMts.accountPushTokenCopied,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 14.0);
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Text(token,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'mtswide',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        )
      ]
    );
  }

} // class Account