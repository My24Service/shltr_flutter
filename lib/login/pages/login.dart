import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shltr_flutter/core/i18n_mixin.dart';
import 'package:shltr_flutter/login/widgets/login.dart';
import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with i18nMixin {
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
                  title: Text('login.app_bar_title'.tr()),
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
      createSnackBar(context, $trans('snackbar_logged_in'));
    }

    // TODO handle login errors
    //             Text('login.dialog_error_title'.tr()),
    //             Text('login.dialog_error_content'.tr())
  }

  Widget _getBody(context, state) {
    if (state is HomeState) {
      return LoginWidget(user: state.user, member: state.member);
    }

    if (state is HomeLoggedInState) {
      return LoginWidget(user: state.user, member: state.member);
    }

    return loadingNotice();
  }
}
