import 'package:flutter/material.dart';
import 'package:my24_flutter_equipment/pages/equipment/detail.dart';

import 'package:shltr_flutter/orders/pages/function_types.dart';

import '../../common/drawers.dart';

class EquipmentDetailPage extends BaseEquipmentDetailPage {
  final bool? withoutDrawer;

  EquipmentDetailPage({
    super.key,
    super.pk,
    super.uuid,
    required super.bloc,
    this.withoutDrawer
  }) : super(
      navDetailFunction: navDetailFunction
  );

  @override
  Future<Widget?> getDrawerForUserWithSubmodel(BuildContext context, String? submodel) async {
    if (withoutDrawer != null && withoutDrawer!) {
      return null;
    }

    return await getDrawerForUserWithSubmodelLocal(context, submodel);
  }
}
