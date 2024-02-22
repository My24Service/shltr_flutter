import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_states.dart';
import 'package:my24_flutter_orders/models/order/models.dart';

import 'form_data.dart';

class OrderBloc extends OrderBlocBase {

  OrderBloc() : super(OrderInitialState()) {
    on<OrderEvent>((event, emit) async {
      if (event.status == OrderEventStatus.newOrder) {
        await _handleNewFormDataState(event, emit);
      } else {
        await handleEvent(event, emit);
      }
    },
    transformer: sequential());
  }

  @override
  OrderFormData createFromModel(Order order, OrderTypes orderTypes) {
    return OrderFormData.createFromModel(order, orderTypes);
  }

  Future<void> _handleNewFormDataState(OrderEvent event, Emitter<OrderState> emit) async {
    final OrderTypes orderTypes = await api.fetchOrderTypes();
    OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
    orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;

    emit(OrderNewState(
        formData: orderFormData
    ));
  }
}