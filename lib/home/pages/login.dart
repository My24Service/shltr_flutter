import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my24_flutter_core/i18n.dart';
import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_equipment/blocs/equipment_bloc.dart';
import 'package:my24_flutter_member_models/public/models.dart';

import 'package:shltr_flutter/home/widgets/login.dart';
import 'package:shltr_flutter/common/widgets.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

import '../../equipment/pages/detail.dart';

class LoginPage extends StatelessWidget {
  final My24i18n i18n = My24i18n(basePath: "login");
  final HomeBloc bloc;
  final String? initialMode;
  final HomeDoLoginState? loginState;
  final Member? memberFromHome;
  final CoreUtils coreUtils = CoreUtils();
  final String languageCode;
  final String? equipmentUuid;
  final EquipmentBloc? equipmentBloc; // only here for testability

  LoginPage({
    super.key,
    required this.bloc,
    this.initialMode,
    this.loginState,
    this.memberFromHome,
    required this.languageCode,
    this.equipmentUuid,
    this.equipmentBloc
  });

  HomeBloc _initialCall() {
    if (initialMode == null) {
      bloc.add(HomeEvent(
        status: HomeEventStatus.getPreferences,
        memberFromHome: memberFromHome
      ));
    } else if (initialMode == "login") {
      bloc.add(HomeEvent(
          status: HomeEventStatus.doLogin,
          doLoginState: loginState
      ));
    }

    return bloc;
  }

  Future<String> getTitle() async {
    final bool isLoggedIn = await coreUtils.isLoggedInSlidingToken();
    final title = isLoggedIn ? i18n.$trans('app_bar_title_logged_in') : i18n.$trans('app_bar_title');
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getTitle(),
        builder: (context, dynamic snapshot) {
          if (!snapshot.hasData) {
            return loadingNotice();
          }

          String title = snapshot.data;

          return BlocProvider<HomeBloc>(
            create: (context) => _initialCall(),
            child: BlocConsumer<HomeBloc, HomeBaseState>(
                listener: (context, state) {
                  _handleListeners(context, state);
                },
                builder: (context, state) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(title),
                      centerTitle: true,
                    ),
                    body: _getBody(context, state),
                  );
                }
            )
          );
        }
    );
  }

  void _handleListeners(BuildContext context, state) {
    if (state is HomeLoggedInState) {
      createSnackBar(context, i18n.$trans('snackbar_logged_in'));
    }

    if (state is HomeLoginErrorState) {
      createSnackBar(context, i18n.$trans('snackbar_error_logging_in'));
    }

    if (state is HomeSoonState) {
      createSnackBar(context, i18n.$trans('snackbar_soon'));
    }
  }

  Widget _getBody(context, state) {
    if (((state is HomeLoggedInState) || (state is HomeState && state.user != null)) && equipmentUuid != null) {
      return EquipmentDetailPage(
        bloc: equipmentBloc != null ? equipmentBloc! : EquipmentBloc(),
        uuid: equipmentUuid,
      );
    }

    if (state is HomeState || state is HomeLoggedInState || state is HomeSoonState) {
      return LoginWidget(
        user: state.user,
        member: state.member,
        i18n: i18n,
        languageCode: languageCode,
        equipmentUuid: equipmentUuid,
      );
    }

    if (state is HomeLoginErrorState) {
      return LoginWidget(
        user: null,
        member: state.member,
        i18n: i18n,
        languageCode: languageCode,
        equipmentUuid: equipmentUuid,
      );
    }

    return loadingNotice();
  }
}
