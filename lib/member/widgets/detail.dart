import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shltr_flutter/login/pages/login.dart';
import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/member/models/models.dart';
import 'package:shltr_flutter/member/models/public/models.dart';
import 'package:shltr_flutter/home/pages/home.dart';

// ignore: must_be_immutable
class MemberDetailWidget extends StatelessWidget {
  final MemberDetailData detailData;

  MemberDetailWidget({
    Key? key,
    required this.detailData,
  }) : super(key: key);

  Widget _buildLogo(Member? member) => SizedBox(
      width: 100,
      height: 210,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (member != null)
              Image.network(member.companylogoUrl!,
                  cacheWidth: 100),
          ]
      )
  );

  Widget _getButton(String? submodel, BuildContext context) {
    // do nothing when no value yet
    if (detailData.isLoggedIn == null) {
      return SizedBox(height: 1);
    }

    if (detailData.isLoggedIn == true) {
      // TODO go somewhere
    }

    return Container(
        child: Center(
            child: createDefaultElevatedButton(
                'member_detail.button_login'.tr(),
                () {
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (context) => LoginPage())
                  );
                }
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(detailData.member),
                    Flexible(
                        child: buildMemberInfoCard(context, detailData.member)
                    )
                  ]
              ),
              _getButton(detailData.submodel, context),
            ]
        )
    );
  }
}
