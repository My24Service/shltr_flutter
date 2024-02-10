import 'package:equatable/equatable.dart';

import 'package:my24_flutter_member_models/public/models.dart';

abstract class HomeBaseState extends Equatable {}

class HomeState extends HomeBaseState {
  final dynamic user;
  final Member? member;
  final Member? shltrMember;

  HomeState({
    required this.user,
    required this.member,
    required this.shltrMember
  });

  @override
  List<Object?> get props => [user, member, shltrMember];
}

class HomeInitialState extends HomeBaseState {
  @override
  List<Object> get props => [];
}

class HomeLoggedInState extends HomeBaseState {
  final dynamic user;
  final Member member;

  HomeLoggedInState({
    required this.user,
    required this.member,
  });

  @override
  List<Object?> get props => [user, member];
}

class HomeLoginErrorState extends HomeBaseState {
  final String error;

  HomeLoginErrorState({
    required this.error
  });

  @override
  List<Object> get props => [error];
}

class HomeLoadingState extends HomeBaseState {
  @override
  List<Object> get props => [];
}

class HomeDoLoginState extends HomeBaseState {
  final String companycode;
  final String userName;
  final String password;

  HomeDoLoginState({
    required this.companycode,
    required this.userName,
    required this.password
  });

  @override
  List<Object> get props => [companycode, userName, password];
}
