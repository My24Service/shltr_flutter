import 'package:flutter/material.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:shltr_flutter/orders/pages/detail.dart';
import 'package:shltr_flutter/orders/pages/list.dart';

import '../blocs/order_form_bloc.dart';
import 'form.dart';

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
