import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void setUpLogging() {
  final Map<String, String> envVars = Platform.environment;

  Logger.root.onRecord.listen((record) {
    if (kDebugMode || envVars['TESTING'] != null) {
      debugPrint('${record.loggerName} ${record.level.name}: ${record.time}: ${record.message}');
    }
  });
}