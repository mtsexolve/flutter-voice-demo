part of 'call.dart';


class CallsControlPanel extends StatelessWidget {

  const CallsControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
      log('call_keyboard: state.calls = ${state.calls}');

      return SizedBox(
          width: 320,
          child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CallKey(
                          title: (state.calls.indexWhere((call) => call.callId == state.selectedCallId) < 0
                              ? false
                              : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].muted)
                              ? 'Unmute'
                              : 'Mute',
                          event: (state.calls.indexWhere((call) => call.callId == state.selectedCallId) < 0
                            ? false
                            : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].muted)
                              ? UnMuteScreenEvent(callId: state.selectedCallId ?? "", state: state)
                              : MuteScreenEvent(callId: state.selectedCallId ?? "", state: state),
                        style: ThemesMts.callKeyGrey,
                          icon: Icon(
                            CupertinoIcons.mic_slash_fill,
                            color: (state.calls.indexWhere((call) => call.callId == state.selectedCallId) < 0
                                ? false
                                : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].muted)
                                ? ColorsMts.mtsRed : ColorsMts.black,
                            size: 32,
                          ),
                        state: state,
                        context: context,
                      ),
                      CallKey(
                          title: 'DTMF',
                          event: CallScreenViewChangedEvent(
                              callScreenView: state.callScreenView == CallScreenView.dtmf  ? CallScreenView.call : CallScreenView.dtmf,
                              state: state
                          ),
                          style: ThemesMts.callKeyGrey,
                          icon: const Icon(
                            CupertinoIcons.circle_grid_3x3,
                            color: ColorsMts.black,
                            size:29,
                          ),
                        state: state,
                        context: context,
                      ),
                      CallKeyAudioRoute(
                          state: state,
                          context: context,
                      )
                    ]
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CallKeyDialer(
                          title: 'Add',
                          style: ThemesMts.callKeyGrey,
                          icon: const Icon(
                            CupertinoIcons.plus,
                            color: ColorsMts.black,
                            size: 32,
                          )
                      ),
                      CallKey(
                          title: 'Transfer',
                          event: CallScreenViewChangedEvent(
                              callScreenView: state.callScreenView == CallScreenView.transfer  ? CallScreenView.call : CallScreenView.transfer,
                              state: state
                          ),
                          style: ThemesMts.callKeyGrey,
                          icon: const Icon(
                            CupertinoIcons.arrow_right_arrow_left,
                            color: ColorsMts.black,
                            size: 32,
                          ),
                        state: state,
                        context: context,
                      ),
                      CallKey(
                          title: (state.calls.indexWhere((call) => call.callId == state.selectedCallId) < 0
                              ? false
                              : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].active == true)
                              ? 'Hold' : 'Resume',
                          event: (state.calls.indexWhere((call) =>
                          call.callId == state.selectedCallId) < 0
                              ? false
                              : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].active
                          == true)
                              ? HoldScreenEvent(callId: state.selectedCallId ?? "",)
                              : ResumeScreenEvent(
                                callId: state.selectedCallId ?? "",
                              ),
                          style: ThemesMts.callKeyGrey,
                          icon: Icon(
                              (state.calls.indexWhere((call) =>
                              call.callId == state.selectedCallId) < 0
                                  ? false
                                  : state.calls[state.calls.indexWhere((call) => call.callId == state.selectedCallId)].active == true)
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play,
                            color: ColorsMts.black,
                            size: 32,
                          ),
                        state: state,
                        context: context,
                      ),
                    ]
                ),
                CallKey(
                  title: 'Terminate',
                  event: TerminateScreenEvent(callId: state.selectedCallId ?? ""),
                  style: ThemesMts.callKeyRed,
                  icon: const Icon(
                    CupertinoIcons.phone_down_fill,
                    color: ColorsMts.white,
                    size: 32,
                  ),
                  state: state,
                  context: context,
                ),
              ]
          )
      );
    });
  }
}

class CallKey extends StatelessWidget {
  final String title;
  final ScreenEvent event;
  final Icon icon;
  final ButtonStyle style;
  final CallScreenState state;
  final BuildContext context;

  const CallKey({
    required this.title,
    required this.event,
    required this.icon,
    required this.style,
    required this.state,
    required this.context,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    log('call_keyboard: callKey: state.calls = ${state.calls}, selected = ${state.selectedCallId}');
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        height: 100,
        width: 100,
        child: Column(
            children: [
              OutlinedButton(
                  onPressed: () {

                    context.read<CallBloc>().add(event);
                  },
                  style: style,
                  child: icon
              ),
              Text(
                title,
                style: const TextStyle(
                  color: ColorsMts.black,
                  fontFamily: 'mtswide',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ]
        )
    );
  }
}

class CallKeyDialer extends StatelessWidget {
  final String title;
  final Icon icon;
  final ButtonStyle style;

  const CallKeyDialer({required this.title, required this.icon,
    required this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        height: 100,
        width: 100,
        child: Column (
          children: [
            OutlinedButton(
              onPressed: () {
                const select = SetSelectorOverride(selectorOverride: SelectorOverride.dialer);
                context.read<SelectorBloc>().add(select);
              },
              style: style,
              child: icon
            ),
            Text(
              title,
              style: const TextStyle(
                color: ColorsMts.black,
                fontFamily: 'mtswide',
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ]
        )
    );
  }
}

class CallKeyAudioRoute extends StatelessWidget {
  final CallScreenState state;
  final BuildContext context;

  const CallKeyAudioRoute({
    super.key,
    required this.state,
    required this.context,
  });

  String audioRouteIconPath(AudioRoute audioRoute) {
    switch (audioRoute) {
      case AudioRoute.earpiece:
        return 'assets/images/ic_route_earpiece.svg';
      case AudioRoute.speaker:
        return 'assets/images/ic_route_speaker.svg';
      case AudioRoute.headset:
        return 'assets/images/ic_route_headset.svg';
      case AudioRoute.headphones:
        return 'assets/images/ic_route_headphones.svg';
      case AudioRoute.bluetooth:
        return 'assets/images/ic_route_bluetooth.svg';
      case AudioRoute.unknown:
        return 'assets/images/ic_route_earpiece.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    AudioRouteData? activeAudioRouteData;
    int activeAudioRouteIndex = 0;
    int audioRoutesSize = 0;
    if (state.audioRoutes != null) {
      audioRoutesSize = state.audioRoutes!.length;
      final index = state.audioRoutes!
          .indexWhere((audioRoute) => audioRoute.isActive == true);
      if (index >= 0) {
        activeAudioRouteData = state.audioRoutes![index];
        activeAudioRouteIndex = index;
      }
    }

    return Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: DropdownButton2<String>(
          value: activeAudioRouteData?.name ?? "",
          customButton: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: 100,
              width: 100,
              child: Column(children: [
                OutlinedButton(
                    onPressed: (audioRoutesSize > 2) ? null : (){
                      final newIndex = (activeAudioRouteIndex == 1) ? 0 : 1;
                      context.read<CallBloc>().add(
                        AudioRouteChangedScreenEvent(state: state, name: state.audioRoutes![newIndex].name));
                    },
                    onLongPress: null,
                    style: ThemesMts.callKeyGrey,
                    child: SvgPicture.asset(
                        audioRouteIconPath(
                            activeAudioRouteData?.route ?? AudioRoute.unknown),
                        width: 32,
                        height: 32)),
                Text(
                  activeAudioRouteData?.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    color: ColorsMts.black,
                    fontFamily: 'mtswide',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ])),
          underline: Container(),
          items: (state.audioRoutes ?? []).map((AudioRouteData item) {
            return DropdownMenuItem<String>(
              value: item.name,
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<CallBloc>().add(
                  AudioRouteChangedScreenEvent(state: state, name: newValue));
            }
          },
        ));
  }
}
