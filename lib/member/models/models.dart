import 'package:shltr_flutter/member/models/public/models.dart';

class MemberDetailData {
  final bool? isLoggedIn;
  final String? submodel;
  final Member? member;

  MemberDetailData({
    this.isLoggedIn,
    this.submodel,
    this.member,
  });
}
