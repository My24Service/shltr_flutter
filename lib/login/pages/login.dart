import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my24_flutter_core/i18n.dart';

import 'package:shltr_flutter/login/widgets/login.dart';
import 'package:shltr_flutter/common/widgets.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

class LoginPage extends StatelessWidget {
  final My24i18n i18n = My24i18n(basePath: "login");
  final HomeBloc bloc;

  LoginPage({
    super.key,
    required this.bloc
  });

  HomeBloc _initialCall() {
    bloc.add(const HomeEvent(
        status: HomeEventStatus.getPreferences
    ));

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
        create: (context) => _initialCall(),
        child: BlocConsumer<HomeBloc, HomeBaseState>(
            listener: (context, state) {
              _handleListeners(context, state);
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(i18n.$trans('app_bar_title')),
                  centerTitle: true,
                ),
                body: _getBody(context, state),
              );
            }
        )
    );
  }

  void _handleListeners(BuildContext context, state) {
    if (state is HomeLoggedInState) {
      createSnackBar(context, i18n.$trans('snackbar_logged_in'));
    }

    if (state is HomeLoginErrorState) {
      createSnackBar(context, i18n.$trans('snackbar_error_logging_in'));
    }
  }

  Widget _getBody(context, state) {
    if (state is HomeState || state is HomeLoggedInState || state is HomeLoginErrorState) {
      return LoginWidget(
        user: state.user,
        member: state.member,
        i18n: i18n,
      );
    }

    return loadingNotice();
  }
}
