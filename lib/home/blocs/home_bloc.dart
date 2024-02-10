import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/utils.dart';

import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';
import 'package:my24_flutter_member_models/public/models.dart';

enum HomeEventStatus {
  getPreferences,
  doAsync,
  doLogin
}

final log = Logger('HomeBloc');

class HomeEvent {
  final String? value;
  final HomeEventStatus? status;
  final HomeDoLoginState? doLoginState;

  const HomeEvent({this.value, this.status, this.doLoginState});
}

class HomeBloc extends Bloc<HomeEvent, HomeBaseState> {
  late SharedPreferences prefs;

  HomeBloc() : super(HomeInitialState()) {
    on<HomeEvent>((event, emit) async {
      if (event.status == HomeEventStatus.getPreferences) {
        await _handleGetPreferencesState(event, emit);
      }
      if (event.status == HomeEventStatus.doAsync) {
        _handleDoAsyncState(event, emit);
      }
      if (event.status == HomeEventStatus.doLogin) {
        await _handleDoLoginState(event, emit);
      }
    },
    transformer: sequential());
  }

  void _handleDoAsyncState(HomeEvent event, Emitter<HomeBaseState> emit) {
    emit(HomeLoadingState());
  }

  Future<void> _handleGetPreferencesState(HomeEvent event, Emitter<HomeBaseState> emit) async {
    prefs = await SharedPreferences.getInstance();

    final bool isLoggedIn = await coreUtils.isLoggedInSlidingToken();

    var user = await utils.getUserInfo(withFetch: isLoggedIn);
    Member? member = await utils.getMember(withFetch: false);

    emit(HomeState(
        member: member,
        user: user
    ));
  }

  Future<void> _handleDoLoginState(HomeEvent event, Emitter<HomeBaseState> emit) async {
    try {
      Member? member = await utils.getMember(companycode: event.doLoginState!.companycode, withFetch: true);
      await coreUtils.attemptLogIn(event.doLoginState!.userName, event.doLoginState!.password);
      var user = await utils.getUserInfo();

      emit(HomeLoggedInState(
          member: member!,
          user: user
      ));
    } catch(e) {
      emit(HomeLoginErrorState(
          error: e.toString()
      ));
    }
  }
}
