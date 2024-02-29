import 'package:flutter/material.dart';

import 'package:my24_flutter_core/i18n.dart';
import 'package:my24_flutter_core/models/models.dart';
import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/pages/list.dart';

import '../../common/drawers.dart';
import '../widgets/empty.dart';
import '../widgets/list.dart';

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
  Widget getOrderListEmptyWidget({required widgetsIn, required i18nIn, required fetchEvent}) {
    return OrderListEmptyWidget(
        widgetsIn: widgetsIn,
        i18nIn: i18nIn,
        fetchEvent: fetchEvent
    );
  }

  @override
  Widget getOrderListWidget({List<Order>? orderList, required OrderPageMetaData orderPageMetaData, required OrderEventStatus fetchEvent, String? searchQuery, required PaginationInfo paginationInfo, required CoreWidgets widgetsIn, required My24i18n i18nIn}) {
    return OrderListWidget(
      orderList: orderList,
      orderPageMetaData: orderPageMetaData,
      fetchEvent: fetchMode,
      searchQuery: searchQuery,
      paginationInfo: paginationInfo,
      widgetsIn: widgets,
      i18nIn: i18n,
    );
  }
}
