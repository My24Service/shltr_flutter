import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:shltr_flutter/login/pages/login.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/member/pages/detail.dart';
import 'package:shltr_flutter/home/blocs/preferences_bloc.dart';
import 'package:shltr_flutter/home/blocs/preferences_states.dart';
import 'package:shltr_flutter/app_config.dart';
import 'package:shltr_flutter/member/models/public/models.dart';
import 'package:shltr_flutter/member/models/public/api.dart';
import 'package:shltr_flutter/core/i18n_mixin.dart';
import 'package:shltr_flutter/core/widgets.dart';

final log = Logger('ShltrApp');

class ShltrApp extends StatefulWidget {
  const ShltrApp({super.key});

  @override
  State<ShltrApp> createState() => _ShltrAppState();
}

class _ShltrAppState extends State<ShltrApp> with SingleTickerProviderStateMixin, i18nMixin {
  MemberByCompanycodePublicApi memberApi = MemberByCompanycodePublicApi();
  StreamSubscription? _sub;
  bool memberFromUri = false;
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
        await _getMemberCompanycode(data['cc']);
        setState(() {});
        // _streamSubscription?.cancel();
      }
    }, onError: (error) {
      log.severe('InitSession error: ${error.toString()}');
    });
  }


  Future<bool> _getMemberCompanycode(String companycode) async {
    // fetch member by company code
    try {
      final Member member = await memberApi.get(companycode);
      // print('got member: ${member.name}');

      await utils.storeMemberInfo(
          member.companycode!,
          member.pk!,
          member.name!,
          member.companylogoUrl!,
          member.hasBranches!
      );

      memberFromUri = true;

      return true;
    } catch (e) {
      log.severe("Error fetching member public: $e");
      return false;
    }
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
      await _getMemberCompanycode(parts[0]);
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
        await _getMemberCompanycode(parts[0]);
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

  GetHomePreferencesBloc _initialCall() {
    GetHomePreferencesBloc bloc = GetHomePreferencesBloc();
    bloc.add(const GetHomePreferencesEvent(status: HomeEventStatus.getPreferences));

    return bloc;
  }

  Future<bool> _setBasePrefs() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    AppConfig config = AppConfig();

    await sharedPrefs.setString('apiBaseUrl', config.apiBaseUrl);
    await sharedPrefs.setInt('pageSize', config.pageSize);

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

    return BlocProvider(
      create: (BuildContext context) => _initialCall(),
      child: BlocBuilder<GetHomePreferencesBloc, HomePreferencesBaseState>(
        builder: (context, dynamic state) {
          if (state is! HomePreferencesState) {
            return loadingNotice();
          }

          Locale? locale = utils.lang2locale(state.languageCode);
          final bool isLoggedIn = state.isLoggedIn;

          return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              builder: (context, child) =>
                  MediaQuery(data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true), child: child!),
              locale: locale,
              // builder: (context, child) {
              //   return StreamChat(client: client, child: child);
              // },
              theme: ThemeData(
                  primarySwatch: colorCustom,
                  bottomAppBarTheme: BottomAppBarTheme(color: colorCustom)
              ),
              // home: _getHomePageWidget(state.doSkip),
              home: Scaffold(
                body: FutureBuilder<bool>(
                    future: _setBasePrefs(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return _getHomePageWidget(isLoggedIn);
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                $trans("error_arg", pathOverride: "generic",
                                    namedArgs: {"error": "${snapshot.error}"}
                                )
                            )
                        );
                      } else {
                        return loadingNotice();
                      }
                    }
                ),
              )
          );
        },
      ),
    );
  }

  Widget _getHomePageWidget(bool isLoggedIn) {
    if (!isLoggedIn) {
      return const LoginPage();
    }

    return const MemberPage();
  }
}
