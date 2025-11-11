import 'package:flutter/material.dart';
import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/models/orderline/form_data.dart';
import 'package:my24_flutter_orders/pages/form_from_location.dart';

import '../blocs/order_form_bloc.dart';
import '../widgets/form_from_location.dart';
import 'function_types.dart';

class OrderFormFromLocationPage extends BaseOrderFormFromLocationPage<OrderFormBloc> {
  OrderFormFromLocationPage({
    super.key,
    super.bloc,
    required super.locationUuid,
    required super.locationOrderType,
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
    return OrderFormFromLocationWidget(
      formData: formData,
      widgets: widgets,
      orderlineFormData: orderlineFormData,
      isPlanning: isPlanning,
      orderPageMetaData: orderPageMetaData,
    );
  }
}
