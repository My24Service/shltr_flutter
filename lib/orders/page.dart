import 'package:flutter/material.dart';

import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/models/order/form_data.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/pages/list.dart';

import 'package:shltr_flutter/orders/detail.dart';
import '../common/drawers.dart';
import 'form_widget.dart';

class OrderListPage<OrderBloc> extends BaseOrderListPage {
  OrderListPage({
    super.key,
    required super.bloc,
    required super.fetchMode,
    super.initialMode,
    super.pk
  });

  @override
  Future<Widget?> getDrawerForUserWithSubmodel(BuildContext context, String? submodel) async {
    return await getDrawerForUserWithSubmodelLocal(context, submodel);
  }

  @override
  Widget getOrderFormWidget({
        required dynamic formData,
        required OrderPageMetaData orderPageMetaData,
        required OrderEventStatus fetchEvent,
        required CoreWidgets widgets
    }) {
    return OrderFormWidget(
      orderPageMetaData: orderPageMetaData,
      formData: formData,
      fetchEvent: fetchMode,
      widgetsIn: widgets,
    );
  }

  @override
  void navDetail(BuildContext context, int orderPk, OrderBlocBase<BaseOrderFormData> bloc) {
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderDetailPage(
              orderId: orderPk,
              bloc: bloc,
            )
        )
    );
  }
}
