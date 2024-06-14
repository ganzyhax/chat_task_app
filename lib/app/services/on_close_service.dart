import 'dart:developer';

import 'package:chat_task_app/app/api/api.dart';
import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _handleAppPaused();
    }
    if (state == AppLifecycleState.resumed) {
      _handleAppResumed();
    }
    if (state == AppLifecycleState.detached) {
      _handleAppClosed();
    }
  }

  Future<void> _handleAppPaused() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.getString('userId') ?? '';
    if (userId != '') {
      await ApiClient()
          .updateDocumentField('users', userId, {'isOnline': false});
    }
    log('UPDaetet');
  }

  Future<void> _handleAppResumed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.getString('userId') ?? '';
    if (userId != '') {
      await ApiClient()
          .updateDocumentField('users', userId, {'isOnline': true});
    }
    log('UPDaetet');
  }

  Future<void> _handleAppClosed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.getString('userId') ?? '';
    if (userId != '') {
      await ApiClient()
          .updateDocumentField('users', userId, {'isOnline': false});
    }
    log('UPDaetet');
  }
}
