import 'package:equatable/equatable.dart';

abstract class HomePreferencesBaseState extends Equatable {}

class HomePreferencesState extends HomePreferencesBaseState {
  final String? languageCode;
  final int? memberPk;
  final bool isLoggedIn;

  HomePreferencesState({
    required this.languageCode,
    required this.memberPk,
    required this.isLoggedIn
  });

  @override
  List<Object?> get props => [languageCode, memberPk, isLoggedIn];
}

class HomePreferencesInitialState extends HomePreferencesBaseState {
  @override
  List<Object> get props => [];
}
