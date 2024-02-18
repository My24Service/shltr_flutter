import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:logging/logging.dart';

import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_member_models/public/models.dart';

import 'package:shltr_flutter/common/utils.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

import '../../company/models/models.dart';

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
  final Member? memberFromHome;

  const HomeEvent({
    this.value,
    this.status,
    this.doLoginState,
    this.memberFromHome
  });
}

class HomeBloc extends Bloc<HomeEvent, HomeBaseState> {
  final Utils utils = Utils();
  final CoreUtils coreUtils = CoreUtils();

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
    Member? member = event.memberFromHome;

    try {
      final bool isLoggedIn = await coreUtils.isLoggedInSlidingToken();
      final BaseUser? user = await utils.getUserInfo(withFetch: isLoggedIn);
      if (event.memberFromHome == null) {
        member = await utils.fetchMember();
      }

      emit(HomeState(
          member: member,
          user: user,
      ));
    } catch(e) {
      emit(HomeLoginErrorState(
        error: e.toString(),
        member: member
      ));
    }
  }

  Future<void> _handleDoLoginState(HomeEvent event, Emitter<HomeBaseState> emit) async {
    Member? member;

    try {
      await coreUtils.attemptLogIn(event.doLoginState!.userName, event.doLoginState!.password);
      member = await utils.fetchMember(companycode: event.doLoginState!.companycode);
      final BaseUser? user = await utils.getUserInfo();

      emit(HomeLoggedInState(
          member: member!,
          user: user,
      ));
    } catch(e) {
      emit(HomeLoginErrorState(
        error: e.toString(),
        member: member
      ));
    }
  }
}
