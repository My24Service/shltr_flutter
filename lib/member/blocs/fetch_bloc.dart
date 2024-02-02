import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:shltr_flutter/member/models/public/api.dart';
import 'package:shltr_flutter/member/blocs/fetch_states.dart';
import 'package:shltr_flutter/member/models/public/models.dart';

enum MemberEventStatus {
  fetchMember,
  fetchMembers,
}

class FetchMemberEvent {
  final MemberEventStatus? status;
  final int? pk;

  const FetchMemberEvent({this.pk, this.status});
}

class FetchMemberBloc extends Bloc<FetchMemberEvent, MemberFetchState> {
  MemberListPublicApi listApi = MemberListPublicApi();
  MemberDetailPublicApi detailApi = MemberDetailPublicApi();

  FetchMemberBloc() : super(MemberFetchInitialState()) {
    on<FetchMemberEvent>((event, emit) async {
      if (event.status == MemberEventStatus.fetchMember) {
        await _handleFetchMemberState(event, emit);
      }
      if (event.status == MemberEventStatus.fetchMembers) {
        await _handleFetchMembersState(event, emit);
      }
    },
    transformer: sequential());
  }

  Future<void> _handleFetchMemberState(FetchMemberEvent event, Emitter<MemberFetchState> emit) async {
    try {
      final Member result = await detailApi.detail(event.pk!);
      emit(MemberFetchLoadedState(member: result));
    } catch (e) {
      emit(MemberFetchErrorState(message: e.toString()));
    }
  }

  Future<void> _handleFetchMembersState(FetchMemberEvent event, Emitter<MemberFetchState> emit) async {
    try {
      final Members result = await listApi.list(needsAuth: false);
      emit(MembersFetchLoadedState(members: result));
    } catch(e) {
      emit(MemberFetchErrorState(message: e.toString()));
    }
  }
}
