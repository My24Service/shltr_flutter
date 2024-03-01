import 'package:my24_flutter_equipment/pages/equipment/detail.dart';

import 'package:shltr_flutter/orders/pages/function_types.dart';

class EquipmentDetailPage extends BaseEquipmentDetailPage {
  EquipmentDetailPage({
    super.key,
    required super.bloc,
    required super.pk,
    required super.uuid,
  }) : super(
      navDetailFunction: navDetailFunction
  );
}
