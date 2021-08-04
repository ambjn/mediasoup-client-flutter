import 'dart:async';

import 'package:events2/events2.dart';
import 'package:mediasoup_client_flutter/src/common/logger.dart';

Logger _logger = Logger('EnhancedEventEmitter');

class EnhancedEventEmitter extends EventEmitter {
  EnhancedEventEmitter() : super();
  void safeEmit(String event, [Map<String, dynamic>? args]) {
    try {
      emit(event, args);
    } catch (error) {
      _logger.error(
        'safeEmit() event listener threw an error [event:$event]:$error',
      );
    }
  }

  Future<dynamic> safeEmitAsFuture(String event, [Map<String, dynamic>? args]) async {

    try {
      if (args != null) {
        final Completer<dynamic> completer = Completer<dynamic>();
        args['callback'] = completer.complete;
        args['errback'] = completer.completeError;
        emitAsFuture(event, args);
        return completer.future;
      } else {
        emitAsFuture(event, args);
        return;
      }
    } catch (error) {
      _logger.error(
        'safeEmitAsFuture() event listener threw an error [event:$event]:$error',
      );
    }
  }
}