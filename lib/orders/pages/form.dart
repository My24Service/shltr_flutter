import 'package:flutter/material.dart';

import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/pages/form.dart';

import 'package:shltr_flutter/orders/pages/list.dart';
import '../widgets/form.dart';

class OrderFormPage<OrderFormBloc> extends BaseOrderFormPage {
  OrderFormPage({
    super.key,
    super.bloc,
    required super.fetchMode,
    required super.pk
  });

  @override
  Widget getOrderFormWidget(
      {
        required dynamic formData,
        required OrderPageMetaData orderPageMetaData,
        required OrderEventStatus fetchEvent,
        required CoreWidgets widgets
      }
      ) {
    return OrderFormWidget(
      orderPageMetaData: orderPageMetaData,
      formData: formData,
      fetchEvent: fetchMode,
      widgetsIn: widgets,
    );
  }

  @override
  void navList(BuildContext context, OrderEventStatus fetchMode) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderListPage(
              fetchMode: fetchMode,
              bloc: OrderBloc(),
            )
        )
    );
  }

}
