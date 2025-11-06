import 'package:flutter/material.dart';
import 'package:my24_flutter_equipment/blocs/equipment_bloc.dart';

import 'package:my24_flutter_equipment/pages/location/detail.dart';
import 'package:shltr_flutter/orders/pages/function_types.dart';

import 'equipment_detail.dart';

class LocationDetailPage extends BaseLocationDetailPage {
  final bool? withoutDrawer;

  LocationDetailPage({
    super.key,
    super.pk,
    super.uuid,
    required super.bloc,
    this.withoutDrawer
  }) : super(
    navDetailFunction: navDetailFunction,
    navFormFromLocationFunction: navFormFromLocationFunction
  );

  @override
  Future<Widget?> getDrawerForUserWithSubmodel(BuildContext context, String? submodel) async {
    if (withoutDrawer != null && withoutDrawer!) {
      return null;
    }

    // return await getDrawerForUserWithSubmodelLocal(context, submodel);
    return null;
  }

  @override
  void navEquipmentDetail(BuildContext context, int equipmentPk, {bool? withDrawer}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EquipmentDetailPage(
              bloc: EquipmentBloc(),
              pk: equipmentPk,
              withoutDrawer: true,
            )
        )
    );
  }
}
