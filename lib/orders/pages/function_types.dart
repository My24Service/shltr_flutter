import 'package:flutter/material.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';

import 'package:shltr_flutter/orders/pages/detail.dart';
import 'package:shltr_flutter/orders/pages/list.dart';
import '../blocs/order_form_bloc.dart';
import 'form.dart';
import 'form_from_equipment.dart';

void navFormFunction(BuildContext context, int? orderPk, OrderEventStatus fetchMode) {
  Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => OrderFormPage(
            fetchMode: fetchMode,
            pk: orderPk,
            bloc: OrderFormBloc(),
          )
      )
  );
}

void navListFunction(BuildContext context, OrderEventStatus fetchMode) {
  Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => OrderListPage(
            fetchMode: fetchMode,
            bloc: OrderBloc(),
          )
      )
  );
}

void navDetailFunction(BuildContext context, int orderPk) {
  Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            bloc: OrderBloc(),
            orderId: orderPk,
          )
      )
  );
}

void navFormFromEquipmentFunction(BuildContext context, String uuid, String orderType) {
  Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => OrderFormFromEquipmentPage(
            equipmentUuid: uuid,
            equipmentOrderType: orderType,
            bloc: OrderFormBloc(),
          )
      )
  );
}
