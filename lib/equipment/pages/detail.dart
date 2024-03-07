import 'package:my24_flutter_equipment/pages/equipment/detail.dart';

import 'package:shltr_flutter/orders/pages/function_types.dart';

class EquipmentDetailPage extends BaseEquipmentDetailPage {
  EquipmentDetailPage({
    super.key,
    super.pk,
    super.uuid,
    required super.bloc,
  }) : super(
      navDetailFunction: navDetailFunction
  );
}
