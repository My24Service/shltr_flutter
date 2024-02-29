import 'package:flutter/material.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/pages/list.dart';

import 'package:shltr_flutter/orders/pages/detail.dart';
import 'package:shltr_flutter/orders/pages/form.dart';
import '../../common/drawers.dart';
import '../blocs/order_form_bloc.dart';

class OrderListPage extends BaseOrderListPage {
  OrderListPage({
    super.key,
    required super.bloc,
    required super.fetchMode,
  });

  @override
  Future<Widget?> getDrawerForUserWithSubmodel(BuildContext context, String? submodel) async {
    return await getDrawerForUserWithSubmodelLocal(context, submodel);
  }

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
