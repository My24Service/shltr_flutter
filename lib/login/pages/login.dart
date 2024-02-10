import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my24_flutter_core/i18n.dart';

import 'package:shltr_flutter/login/widgets/login.dart';
import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

class LoginPage extends StatefulWidget {
  final My24i18n i18n = My24i18n(basePath: "login");

  LoginPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  HomeBloc _initialCall() {
    HomeBloc bloc = HomeBloc();
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
                  title: Text(widget.i18n.$trans('app_bar_title')),
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
      createSnackBar(context, widget.i18n.$trans('snackbar_logged_in'));
    }

    if (state is HomeLoginErrorState) {
      createSnackBar(context, widget.i18n.$trans('snackbar_error_logging_in'));
    }
  }

  Widget _getBody(context, state) {
    if (state is HomeState) {
      return LoginWidget(
        user: state.user,
        member: state.member,
        shltrMember: state.shltrMember,
        i18n: widget.i18n,
      );
    }

    if (state is HomeLoggedInState) {
      return LoginWidget(
        user: state.user,
        member: state.member,
        shltrMember: null,
        i18n: widget.i18n,
      );
    }

    return loadingNotice();
  }
}
