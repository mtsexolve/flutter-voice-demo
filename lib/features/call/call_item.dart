part of 'call.dart';

class CallItem extends StatelessWidget {
  final int index;

  const CallItem(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
            bottom: 5
        ),
        child: SizedBox(
            height: 75,
            child: BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
              return GestureDetector(
                  onTap: () {
                    final event =  SelectScreenEvent(callId: state.calls[index].callId, state: state);
                    context.read<CallBloc>().add(event);
                  },
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: ColorsMts.mtsBgGrey,
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: state.calls[index].callId == state.selectedCallId
                                  ? BorderStyle.solid
                                  : BorderStyle.none,
                              strokeAlign: BorderSide.strokeAlignInside
                          )
                      ),
                      child: Row(
                        children: [
                          _getStateIcon(state.calls[index].active == true),
                          Expanded(
                              flex: 2, // 20%
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _getCallNumberRow(index),
                                    Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          _getTerminateButton(index),
                                          state.calls[index].callState != CallState.newCall
                                              ?_getHoldResumeButton(index, state, context)
                                              : (state.calls[index].isOutDirection
                                                ? const SizedBox() : _getAcceptButton(index)) ,
                                        ]
                                    )
                                  ]
                              )
                          )
                        ],
                      )
                  )
              );
            })
        )
    );
  }
}

StatelessWidget _getStateIcon(bool active) {
  return Icon(
    active ? CupertinoIcons.play_fill : CupertinoIcons.pause_fill,
    color: ColorsMts.grey,
    size: 50
  );
}

Widget _getCallNumberRow(int index) {
  return Padding(
      padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 0
      ),
      child: BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
        return Text(state.calls[index].number,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontFamily: 'mtswide',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      })
  );
}

Widget _getTerminateButton(int index) {
  return BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
    return TextButton(
        onPressed: () {
          final event = TerminateScreenEvent(callId: state.calls[index].callId,) ;
          context.read<CallBloc>().add(event);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            side: MaterialStateProperty.all(BorderSide.none),
            overlayColor: MaterialStateProperty.all(ColorsMts.mtsBgGrey)
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.phone_down_fill,
              color: ColorsMts.mtsRed,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text('Terminate',
                style: TextStyle(
                  fontFamily: 'mtswide',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black,
                )
            )
          ],
        )
    );
  });
}

Widget _getHoldResumeButton(index, CallScreenState state, BuildContext context) {
  return state.calls[index].active != null
  ? TextButton(
    onPressed: () {
      final event = state.calls[index].active == true
          ? HoldScreenEvent(
              callId: state.calls[index].callId ,
          ) : ResumeScreenEvent(
                callId: state.calls[index].callId,
          );
      context.read<CallBloc>().add(event);
    },
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        side: MaterialStateProperty.all(BorderSide.none),
        overlayColor: MaterialStateProperty.all(ColorsMts.mtsBgGrey)
    ),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
            return Icon(
              state.calls[index].active == true
                  ? CupertinoIcons.pause_fill
                  : CupertinoIcons.phone_fill,
              color: ColorsMts
                  .mtsButtonAcceptGreen,
              size: 20,
            );
          }),
          const SizedBox(
            width: 5,
          ),
          BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
            return Text(
                state.calls[index].active == true ? 'Hold' : 'Resume',
                style: const TextStyle(
                    fontFamily: 'mtswide',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black
                )
            );
          })
        ]
    )
  ) : const SizedBox();
}
  Widget _getAcceptButton(index) {
    return BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
      return TextButton(
        onPressed: () {
          final event = AcceptScreenEvent(
            callId: state.calls[index].callId,
          );
          context.read<CallBloc>().add(event);
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            side: MaterialStateProperty.all(BorderSide.none),
            overlayColor: MaterialStateProperty.all(ColorsMts.mtsBgGrey)
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
                return const Icon(
                  CupertinoIcons.phone_fill,
                  color: ColorsMts
                      .mtsButtonAcceptGreen,
                  size: 20,
                );
              }),
              const SizedBox(
                width: 5,
              ),
              BlocBuilder<CallBloc, CallScreenState>(builder: (context, state) {
                return const Text('Accept',
                    style: TextStyle(
                        fontFamily: 'mtswide',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black
                    )
                );
              })
            ]
        )
    );
  });
}