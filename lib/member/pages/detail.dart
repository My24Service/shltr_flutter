import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/member/widgets/detail.dart';

import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/member/models/models.dart';

final log = Logger('MemberPage');

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MemberDetailData>(
      future: utils.getMemberDetailData(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          MemberDetailData detailData = snapshot.data!;

          return Scaffold(
              appBar: AppBar(
                title: Text(detailData.member!.name!),
              ),
              body: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MemberDetailWidget(detailData: detailData)
              )
          );
        }  else if (snapshot.hasError) {
          log.severe(snapshot.error);
          return Center(child: Text("An error occurred (${snapshot.error})"));
        } else {
          return Scaffold(
              body: loadingNotice()
          );
        }
      }
    );
  }
}
