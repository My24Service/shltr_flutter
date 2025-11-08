import 'package:flutter/material.dart';
import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/models/orderline/form_data.dart';
import 'package:my24_flutter_orders/pages/form_from_equipment.dart';

import '../blocs/order_form_bloc.dart';
import '../widgets/form_from_equipment.dart';
import 'function_types.dart';

class OrderFormFromEquipmentPage extends BaseOrderFormFromEquipmentPage<OrderFormBloc> {
  OrderFormFromEquipmentPage({
    super.key,
    super.bloc,
    required super.equipmentUuid,
    required super.equipmentOrderType,
  }) : super(
      navDetailFunction: navDetailFunction,
      hasBranches: true
  );

  @override
  Widget getOrderFormWidget({
      required formData,
      required OrderPageMetaData orderPageMetaData,
      required OrderlineFormData orderlineFormData,
      required CoreWidgets widgets,
      required isPlanning
    }) {
    return OrderFormFromEquipmentWidget(
      formData: formData,
      widgets: widgets,
      orderlineFormData: orderlineFormData,
      isPlanning: isPlanning,
      orderPageMetaData: orderPageMetaData,
    );
  }
}
