import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../zephyr_localization.dart';

/// Widget that display a loading page, containing a [CircularProgressIndicator], a "Loading" text (translated) and a
/// funny loading message that changes every now and then.
class LoadingPage extends StatefulWidget {
  static const Duration defaultWaitingInterval = Duration(seconds: 4);

  final Duration waitingInterval;

  /// Default constructor for [LoadingPage]. You can customize the interval of time to wait between two messages
  /// with [waitingInterval] (defaults to 4 seconds).
  LoadingPage({Key key, this.waitingInterval = defaultWaitingInterval}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

/// State for [LoadingPage]. It manages the different messages through [nextMessage].
class _LoadingPageState extends State<LoadingPage> {
  /// [keepGeneratingMessage] keeps the [nextMessage] running while its value is `true`. If you want to stop
  /// [nextMessage] from generating more message, turn it to `false`.
  bool keepGeneratingMessage = true;

  /// The list containing all loading messages. It requires a [BuildContext] to be loaded.
  List<List<String>> messages = null;

  @override
  void dispose() {
    keepGeneratingMessage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    messages = ZephyrLocalization.of(context).allLoadingMessages();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(key: Key("loading_signs_results")),
          SizedBox(height: 32),
          Text(ZephyrLocalization.of(context).loading(), style: TextStyle(fontSize: 18)),
          SizedBox(height: 32),
          // TODO: Start displaying loading message after 1 second of loading
          StreamBuilder<String>(
            stream: nextMessage(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              String message = snapshot.data != null && snapshot.data.length > 0 ? snapshot.data : '';
              return AnimatedSwitcher(
                key: Key("loading_animated_switcher"),
                duration: Duration(milliseconds: 200),
                child: Text(
                  message,
                  key: Key("loading_message_${message.hashCode}"),
                  style: TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Function that generate a continuous stream of message, until either [dispose] is called or [keepGeneratingMessage]
  /// if `false`.
  ///
  /// The generated messages are selected randomly, but with an algorithm that prefer to select messages that was never
  /// chose until now, rather than the messages that were already sent. When all possible messages have been sent, the
  /// history list is automatically repeated so the function keeps generating messages. Certain messages have a
  /// follow-up, which is respected by the function. You can customize the interval of time to wait between two messages
  /// with [waitingInterval].
  Stream<String> nextMessage({Duration waitingInterval}) async* {
    if (waitingInterval == null) waitingInterval = widget.waitingInterval;

    assert(messages != null, "The list of messages must initialized.");

    // History of indices. It is reset when all messages have been sent
    List<int> indicesAlreadyYielded = <int>[];

    // The current message and its follow-up (if any) being processed by the loop
    List<String> messagesList = null;

    // The index showing which message from [messagesList] were sent from the last iteration
    int lastMessageIndex = -1;

    // Placeholder containing the next message to yield
    String nextMessage = null;

    // Main loop generating messages
    while (keepGeneratingMessage) {
      // Check if there is a follow-up of the previous message
      if (messagesList != null && lastMessageIndex >= 0 && lastMessageIndex + 1 < messagesList.length) {
        nextMessage = messagesList[++lastMessageIndex];
      } else {
        // If all messages has been done, reset the counter
        if (indicesAlreadyYielded.length == messages.length) indicesAlreadyYielded.clear();

        // Search for a next index
        int nextIndex = -1;
        // TODO: In theory, this loop could take forever. Optimize it with sets
        do {
          nextIndex = Random().nextInt(messages.length);
        } while (indicesAlreadyYielded.contains(nextIndex));

        // Add the index to the history list
        indicesAlreadyYielded.add(nextIndex);

        messagesList = messages[nextIndex];
        lastMessageIndex = 0;

        // Yield the message
        nextMessage = messagesList[lastMessageIndex];
      }
      yield nextMessage;

      await Future.delayed(waitingInterval);
    }

    if (kDebugMode) print("Finished nextMessage() stream.");
  }
}
