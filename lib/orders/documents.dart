import 'package:flutter/material.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/pages/documents.dart';

import 'package:shltr_flutter/orders/page.dart';
import 'order_bloc.dart';

class OrderDocumentsPage extends BaseOrderDocumentsPage {
  OrderDocumentsPage({
    super.key,
    required super.orderId,
    required super.bloc
  });

  @override
  void navOrders(BuildContext context, OrderEventStatus fetchMode) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderListPage(
              bloc: OrderBloc(),
              fetchMode: fetchMode,
            )
        )
    );
  }
}