import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shltr_flutter/core/utils.dart';

import 'package:shltr_flutter/home/blocs/preferences_states.dart';

enum HomeEventStatus { getPreferences }

final log = Logger('GetHomePreferencesBloc');

class GetHomePreferencesEvent {
  final String? value;
  final HomeEventStatus? status;

  const GetHomePreferencesEvent({this.value, this.status});
}

class GetHomePreferencesBloc extends Bloc<GetHomePreferencesEvent, HomePreferencesBaseState> {
  late SharedPreferences prefs;

  GetHomePreferencesBloc() : super(HomePreferencesInitialState()) {
    on<GetHomePreferencesEvent>((event, emit) async {
      if (event.status == HomeEventStatus.getPreferences) {
        await _handleGetPreferencesState(event, emit);
      }
    },
    transformer: sequential());
  }

  Future<void> _handleGetPreferencesState(GetHomePreferencesEvent event, Emitter<HomePreferencesBaseState> emit) async {
    final HomePreferencesState result = await _getPreferences(event.value);
    emit(result);
  }

  Future<HomePreferencesState> _getPreferences(String? contextLanguageCode) async {
    prefs = await SharedPreferences.getInstance();
    String? languageCode;
    int? memberPk;

    final bool isLoggedIn = await utils.isLoggedInSlidingToken();

    // check the default language
    if (!prefs.containsKey('preferred_language_code')) {
      if (contextLanguageCode != null) {
        await prefs.setString('preferred_language_code', contextLanguageCode);
      } else {
        log.info('not setting contextLanguageCode, it\'s null');
      }
    } else {
      languageCode = prefs.getString('preferred_language_code');
      if (languageCode != null) {
        await prefs.setString('preferred_language_code', languageCode);
      }
    }

    languageCode = prefs.getString('preferred_language_code');
    log.info('memberPk: $memberPk');

    return HomePreferencesState(
      languageCode: languageCode,
      memberPk: memberPk,
      isLoggedIn: isLoggedIn
    );
  }
}
