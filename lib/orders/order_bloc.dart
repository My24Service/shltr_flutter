import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_states.dart';
import 'package:my24_flutter_orders/models/order/models.dart';

import '../company/api/company_api.dart';
import '../company/models/models.dart';
import 'form_data.dart';

class OrderBloc extends OrderBlocBase {
  final CoreUtils coreUtils = CoreUtils();
  final CompanyApi companyApi = CompanyApi();

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
    String? submodel = await coreUtils.getUserSubmodel();
    OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
    orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;

    if (submodel == 'branch_employee_user') {
      final Branch branch = await companyApi.fetchMyBranch();
      orderFormData.fillFromBranch(branch);
    }

    emit(OrderNewState(
        formData: orderFormData
    ));
  }
}