import 'dart:convert';
import 'dart:async';
import 'Channels.dart';
import 'WindowController.dart';
import 'WindowControllerImpl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DesktopMultiWindow {
  static Future<WindowController> createWindow([String? arguments]) async {
    final windowId = await multiWindowChannel.invokeMethod<int>(
      'createWindow',
      arguments,
    );
    assert(windowId != null, 'windowId is null');
    assert(windowId! > 0, 'id must be greater than 0');
    return WindowControllerMainImpl(windowId!);
  }

  static Future<dynamic> invokeMethod(int targetWindowId, String method,
      [dynamic arguments]) {
    return windowEventChannel.invokeMethod(method, <String, dynamic>{
      'targetWindowId': targetWindowId,
      'arguments': arguments,
    });
  }

  static void setMethodHandler(
      Future<dynamic> Function(MethodCall call, int fromWindowId)? handler) {
    if (handler == null) {
      windowEventChannel.setMethodCallHandler(null);
      return;
    }
    windowEventChannel.setMethodCallHandler((call) async {
      final fromWindowId = call.arguments['fromWindowId'] as int;
      final arguments = call.arguments['arguments'];
      final result =
          await handler(MethodCall(call.method, arguments), fromWindowId);
      return result;
    });
  }

  /// Get all sub window id.
  static Future<List<int>> getAllSubWindowIds() async {
    final result = await multiWindowChannel
        .invokeMethod<List<dynamic>>('getAllSubWindowIds');
    final ids = result?.cast<int>() ?? const [];
    assert(!ids.contains(0), 'ids must not contains main window id');
    assert(ids.every((id) => id > 0), 'id must be greater than 0');
    return ids;
  }
}

Future<void> createAndShowWindow() async {
  final window = await DesktopMultiWindow.createWindow(jsonEncode({
    'args1': 'Sub window',
    'args2': 100,
    'args3': true,
    'bussiness': 'bussiness_test',
  }));

  window
    ..setFrame(const Offset(0, 0) & const Size(1280, 720))
    ..center()
    ..setTitle('Another window')
    ..show();
}
