import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:uni_links/uni_links.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import 'package:my24_flutter_core/utils.dart';

import 'package:shltr_flutter/login/pages/login.dart';
import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/core/i18n_mixin.dart';
import 'package:shltr_flutter/core/widgets.dart';

final log = Logger('ShltrApp');

class ShltrApp extends StatefulWidget {
  const ShltrApp({super.key});

  @override
  State<ShltrApp> createState() => _ShltrAppState();
}

class _ShltrAppState extends State<ShltrApp> with SingleTickerProviderStateMixin, i18nMixin {
  StreamSubscription? _sub;
  StreamSubscription<Map>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
    _listenDynamicLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _listenDynamicLinks() async {
    // int? memberPk = await utils.getPreferredMemberPk();
    // if (memberPk != null) {
    //   print("memberPk: $memberPk");
    //   return;
    // }
    _streamSubscription = FlutterBranchSdk.listSession().listen((data) async {
      log.info('listenDynamicLinks - DeepLink Data: $data');
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        // Link clicked. Add logic to get link data
        if (data['cc'] == 'open') {
          return;
        }
        log.info('Company code: ${data["cc"]}');
        await utils.getMember(companycode: data['cc']);
        setState(() {});
        // _streamSubscription?.cancel();
      }
    }, onError: (error) {
      log.severe('InitSession error: ${error.toString()}');
    });
  }

  bool _isCompanycodeOkay(String host) {
    if (host == 'open' || host.contains('fsnmb') || host == 'link' ||
        host == 'www') {
      return false;
    }

    return true;
  }

  void _handleIncomingLinks() async {
    // It will handle app links while the app is already started - be it in
    // the foreground or in the background.
    _sub = uriLinkStream.listen((Uri? uri) async {
      if (!mounted) return;
      log.info('got host: ${uri!.host}');
      List<String>? parts = uri.host.split('.');
      if (!_isCompanycodeOkay(parts[0])) return;
      await utils.getMember(companycode: parts[0]);
      setState(() {});
    }, onError: (Object err) {
      if (!mounted) return;
      // print('got err: $err');
      setState(() {});
    });
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri == null) {
        log.info('no initial uri');
      } else {
        if (!mounted) return;
        log.info('got initial uri: $uri');
        List<String>? parts = uri.host.split('.');
        if (!_isCompanycodeOkay(parts[0])) return;
        await utils.getMember(companycode: parts[0]);
        setState(() {});
      }
      setState(() {});
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
      log.warning('failed to get initial uri');
    } on FormatException catch (err) {
      if (!mounted) return;
      log.warning('malformed initial uri: $err');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color.fromARGB(255, 48, 191, 191);
    Map<int, Color> color = {
      50: themeColor,
      100: themeColor,
      200: themeColor,
      300: themeColor,
      400: themeColor,
      500: themeColor,
      600: themeColor,
      700: themeColor,
      800: themeColor,
      900: themeColor,
    };

    MaterialColor colorCustom = MaterialColor(0xFF30BFBF, color);

    return FutureBuilder<String?>(
      future: utils.getLanguageCode(context.deviceLocale.languageCode),
      builder: (context, dynamic snapshot) {
          if (!snapshot.hasData) {
            return loadingNotice();
          }

          Locale? locale = coreUtils.lang2locale(snapshot.data);

          return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              builder: (context, child) =>
                  MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: true),
                      child: child!
                  ),
              locale: locale,
              theme: ThemeData(
                  primarySwatch: colorCustom,
                  bottomAppBarTheme: BottomAppBarTheme(color: colorCustom)
              ),
              home: const Scaffold(
                body: LoginPage(),
              )
          );
        },
      );
  }
}
