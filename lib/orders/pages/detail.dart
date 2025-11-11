import 'package:flutter/material.dart';
import 'package:my24_flutter_orders/pages/detail.dart';

import '../../common/drawers.dart';

class OrderDetailPage<OrderBloc> extends BaseOrderDetailPage {
  final bool? withoutDrawer;

  OrderDetailPage({
    super.key,
    required super.bloc,
    required super.orderId,
    this.withoutDrawer
  });

  @override
  Future<Widget?> getDrawer(BuildContext context, String? submodel) async {
    if (withoutDrawer != null && withoutDrawer!) {
      return null;
    }

    return await getDrawerForUserWithSubmodelLocal(context, submodel);
  }
}