import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_equipment/models/equipment/models.dart';
import 'package:my24_flutter_equipment/models/location/models.dart';
import 'package:my24_flutter_orders/blocs/order_form_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_form_states.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/models/orderline/models.dart';

import '../../company/models/branch/api.dart';
import '../../company/models/branch/models.dart';
import '../models/form_data.dart';

class OrderFormBloc extends OrderFormBlocBase {
  final CoreUtils coreUtils = CoreUtils();
  final BranchApi branchApi = BranchApi();
  final MyBranchApi myBranchApi = MyBranchApi();

  OrderFormBloc() : super(OrderFormInitialState()) {
    on<OrderFormEvent>((event, emit) async {
      if (event.status == OrderFormEventStatus.newOrder) {
        await _handleNewFormDataState(event, emit);
      }
      else if (event.status == OrderFormEventStatus.newOrderFromEquipmentBranch) {
        await _handleNewFormDataFromEquipmentState(event, emit);
      }
      else if (event.status == OrderFormEventStatus.newOrderFromLocationBranch) {
        await _handleNewFormDataFromLocationState(event, emit);
      }
      else {
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
    final String? submodel = await coreUtils.getUserSubmodel();
    final bool isPlanning = await _isPlanning(submodel: submodel);
    OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
    orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;
    Branch? branch;

    if (submodel == 'branch_employee_user') {
      branch = await myBranchApi.fetchMyBranch();
      orderFormData.fillFromBranch(branch);
    }

    orderFormData.canCreateLocation = _canCreateLocation(
        isPlanning, orderFormData
    );
    orderFormData.canCreateEquipment = _canCreateEquipment(
        isPlanning, orderFormData
    );
    List<EquipmentLocation> locations = [];

    if (!orderFormData.canCreateLocation) {
      locations = await locationApi.fetchLocationsForSelect(
          branch: branch?.id,
          customerPk: null
      );
    }

    orderFormData.locations = locations;

    emit(OrderNewState(
        formData: orderFormData
    ));
  }

  _canCreateLocation(bool isPlanning, OrderFormData formData) {
    return (isPlanning && formData.quickCreateSettings!.equipmentLocationPlanningQuickCreate) ||
        (!isPlanning && formData.quickCreateSettings!.equipmentLocationQuickCreate);
  }

  _canCreateEquipment(bool isPlanning, OrderFormData formData) {
    return (isPlanning && formData.quickCreateSettings!.equipmentPlanningQuickCreate) ||
        (!isPlanning && formData.quickCreateSettings!.equipmentQuickCreate);
  }

  Future<bool> _isPlanning({String? submodel}) async {
    submodel ??= await coreUtils.getUserSubmodel();
    return submodel == 'planning_user';
  }

  Future<void> _handleNewFormDataFromEquipmentState(OrderFormEvent event, Emitter<OrderFormState> emit) async {
    try {
      final String? submodel = await coreUtils.getUserSubmodel();
      final bool isPlanning = await _isPlanning(submodel: submodel);
      final OrderTypes orderTypes = await api.fetchOrderTypes();
      final Equipment equipment = await equipmentApi.getByUuid(event.equipmentUuid!);
      Branch branch;

      if (submodel == 'branch_employee_user') {
        branch = await myBranchApi.fetchMyBranch();
        if (branch.id != equipment.branch!) {
          throw "Equipment not for your branch";
        }
      } else {
        branch = await branchApi.detail(equipment.branch!);
      }

      OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
      orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;
      orderFormData.orderType = event.equipmentOrderType!;
      orderFormData.fillFromBranch(branch);
      orderFormData.canCreateLocation = _canCreateLocation(
          isPlanning, orderFormData
      );
      orderFormData.canCreateEquipment = _canCreateEquipment(
          isPlanning, orderFormData
      );
      List<EquipmentLocation> locations = [];

      if (!orderFormData.canCreateLocation) {
        locations = await locationApi.fetchLocationsForSelect(
          branch: branch.id,
          customerPk: null
        );
      }

      Orderline orderline = Orderline(
        product: equipment.name,
        location: equipment.locationName,
        equipment: equipment.id,
        equipmentLocation: equipment.location,
      );

      orderFormData.orderLines!.add(orderline);
      orderFormData.locations = locations;

      emit(OrderNewState(
          formData: orderFormData
      ));
    } catch (e) {
      emit(OrderFormErrorState(message: e.toString()));
    }
  }

  Future<void> _handleNewFormDataFromLocationState(OrderFormEvent event, Emitter<OrderFormState> emit) async {
    try {
      final String? submodel = await coreUtils.getUserSubmodel();
      final bool isPlanning = await _isPlanning(submodel: submodel);
      final OrderTypes orderTypes = await api.fetchOrderTypes();
      final EquipmentLocation location = await locationApi.getByUuid(event.locationUuid!);
      Branch branch;

      if (submodel == 'branch_employee_user') {
        branch = await myBranchApi.fetchMyBranch();
        if (branch.id != location.branch!) {
          throw "Equipment not for your branch";
        }
      } else {
        branch = await branchApi.detail(location.branch!);
      }

      OrderFormData orderFormData = OrderFormData.newFromOrderTypes(orderTypes);
      orderFormData = await addQuickCreateSettings(orderFormData) as OrderFormData;
      orderFormData.orderType = event.locationOrderType!;
      orderFormData.fillFromBranch(branch);
      orderFormData.canCreateLocation = _canCreateLocation(
          isPlanning, orderFormData
      );
      orderFormData.canCreateEquipment = _canCreateEquipment(
          isPlanning, orderFormData
      );
      List<EquipmentLocation> locations = [];

      if (!orderFormData.canCreateLocation) {
        locations = await locationApi.fetchLocationsForSelect(
            branch: branch.id,
            customerPk: null
        );
      }

      Orderline orderline = Orderline(
        location: location.name,
        equipmentLocation: location.id,
      );

      orderFormData.orderLines!.add(orderline);
      orderFormData.locations = locations;

      emit(OrderNewState(
          formData: orderFormData
      ));
    } catch (e) {
      emit(OrderFormErrorState(message: e.toString()));
    }
  }
}
