import 'package:flutter/material.dart';

class StateUtils {
  static void runOnPostFrame(Function callable) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await callable();
    });
  }

  static void listenToLifecycle({resumeCallBack, suspendingCallBack}) async {
    WidgetsBinding.instance.addObserver(new LifecycleEventHandler(
        resumeCallBack: resumeCallBack,
        suspendingCallBack: suspendingCallBack));
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.suspendingCallBack});

  final VoidCallback resumeCallBack;
  final VoidCallback suspendingCallBack;

  @override
  Future<Null> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.suspending:
        if (suspendingCallBack != null) suspendingCallBack();
        break;
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) resumeCallBack();
        break;
    }
  }
}
