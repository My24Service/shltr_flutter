import 'package:flutter/material.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';

import 'package:my24_flutter_orders/widgets/list.dart';

import '../blocs/order_form_bloc.dart';
import '../pages/detail.dart';
import '../pages/form.dart';

class OrderListWidget extends BaseOrderListWidget {
  OrderListWidget({
    super.key,
    required super.orderList,
    required super.orderPageMetaData,
    required super.fetchEvent,
    required super.searchQuery,
    required super.paginationInfo,
    required super.widgetsIn,
    required super.i18nIn
  });

  @override
  void navDetail(BuildContext context, int orderPk) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              orderId: orderPk,
              bloc: OrderBloc(),
            )
        )
    );
  }

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
