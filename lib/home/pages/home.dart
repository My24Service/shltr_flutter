import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logging/logging.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:my24_flutter_member_models/public/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import 'package:my24_flutter_core/utils.dart';

import 'package:shltr_flutter/home/pages/login.dart';
import 'package:shltr_flutter/common/utils.dart';
import 'package:shltr_flutter/common/widgets.dart';

import '../../app_config.dart';
import '../blocs/home_bloc.dart';

final log = Logger('ShltrApp');

class ShltrApp extends StatefulWidget {
  const ShltrApp({super.key});

  @override
  State<ShltrApp> createState() => _ShltrAppState();
}

class _ShltrAppState extends State<ShltrApp> with SingleTickerProviderStateMixin {
  StreamSubscription? _sub;
  StreamSubscription<Map>? _streamSubscription;
  Member? member;
  String? equipmentUuid;

  @override
  void initState() {
    super.initState();
    _setBasePrefs();
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
    _streamSubscription = FlutterBranchSdk.listSession().listen((data) async {
      log.info('listenDynamicLinks - DeepLink Data: $data');
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        // Link clicked. Add logic to get link data
        if (data['cc'] == 'open') {
          return;
        }
        log.info('Company code: ${data["cc"]}');
        member = await utils.fetchMember(companycode: data['cc']);

        if (data.containsKey('equipment')) {
          equipmentUuid = data['equipment'];
        }

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
      member = await utils.fetchMember(companycode: parts[0]);
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
        member = await utils.fetchMember(companycode: parts[0]);
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

  Future<bool> _setBasePrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    // AppConfig config = kDebugMode ? AppConfig(protocol: "http") : AppConfig();
    AppConfig config = AppConfig();
    await sharedPrefs.setString('apiBaseUrl', config.apiBaseUrl);
    await sharedPrefs.setInt('pageSize', config.pageSize);
    await sharedPrefs.setString('apiProtocol', config.protocol);

    return true;
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

          String languageCode = snapshot.data;
          Locale? locale = coreUtils.lang2locale(snapshot.data);

          return MaterialApp(
              debugShowCheckedModeBanner: false,
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
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: colorCustom,
                    primary: colorCustom,
                    brightness: Brightness.light,
                  ),
                  bottomAppBarTheme: BottomAppBarTheme(color: colorCustom)
              ),
              home: Scaffold(
                body: LoginPage(
                  languageCode: languageCode,
                  bloc: HomeBloc(),
                  memberFromHome: member,
                  equipmentUuid: equipmentUuid,
                ),
              )
          );
        },
      );
  }
}
