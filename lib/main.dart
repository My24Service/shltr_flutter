import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import 'package:my24_flutter_core/dev_logging.dart';
// import 'package:shltr_flutter/common/utils.dart';

import 'package:shltr_flutter/home/pages/home.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await FlutterBranchSdk.init(
      useTestKey: false, enableLogging: false, disableTracking: false);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await utils.logout();

  setUpLogging();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('nl', 'NL'),
          // Locale('de', 'DE'),
        ],
        path: 'resources/langs',
        fallbackLocale: const Locale('en', 'US'),
        child: const ShltrApp()
    ),
  );
}
