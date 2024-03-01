import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_orders/blocs/order_form_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_form_states.dart';
import 'package:my24_flutter_orders/models/order/models.dart';

import '../../company/models/branch/api.dart';
import '../../company/models/branch/models.dart';
import '../models/form_data.dart';

class OrderFormBloc extends OrderFormBlocBase {
  final CoreUtils coreUtils = CoreUtils();
  final MyBranchApi branchApi = MyBranchApi();

  OrderFormBloc() : super(OrderFormInitialState()) {
    on<OrderFormEvent>((event, emit) async {
      if (event.status == OrderFormEventStatus.newOrder) {
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

  Future<void> _handleNewFormDataState(OrderFormEvent event, Emitter<OrderFormState> emit) async {
    final OrderTypes orderTypes = await api.fetchOrderTypes();
    String? submodel = await coreUtils.getUserSubmodel();
    OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
    orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;

    if (submodel == 'branch_employee_user') {
      final Branch branch = await branchApi.fetchMyBranch();
      orderFormData.fillFromBranch(branch);
    }

    emit(OrderNewState(
        formData: orderFormData
    ));
  }
}