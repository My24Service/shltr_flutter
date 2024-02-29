import 'package:flutter/material.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';

import 'package:my24_flutter_orders/widgets/empty.dart';

import '../blocs/order_form_bloc.dart';
import '../pages/form.dart';

class OrderListEmptyWidget extends BaseOrderListEmptyWidget {
  OrderListEmptyWidget({super.key, required super.widgetsIn, required super.i18nIn, required super.fetchEvent});

  @override
  void navForm(BuildContext context, int? orderPk, OrderEventStatus fetchMode) {
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
}
