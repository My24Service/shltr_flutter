import 'package:my24_flutter_orders/models/order/form_data.dart';
import 'package:my24_flutter_orders/models/order/models.dart';

import '../company/models/models.dart';

class OrderFormData extends BaseOrderFormData {
  OrderFormData({
    super.id,
    super.typeAheadControllerCustomer,
    super.typeAheadControllerBranch,
    super.customerPk,
    super.customerId,
    super.branch,
    super.orderlineFormData,
    super.infolineFormData,
    super.orderCustomerIdController,
    super.orderNameController,
    super.orderAddressController,
    super.orderPostalController,
    super.orderCityController,
    super.orderContactController,
    super.orderReferenceController,
    super.customerRemarksController,
    super.orderEmailController,
    super.orderMobileController,
    super.orderTelController,

    super.orderLines,
    super.deletedOrderLines,
    super.infoLines,
    super.deletedInfoLines,

    super.startDate,
    super.startTime,
    super.endDate,
    super.endTime,
    super.changedEndDate,
    super.orderTypes,
    super.orderType,
    super.orderCountryCode,
    super.customerOrderAccepted,
    super.locations,
    super.error,
    super.isCreatingEquipment,
    super.isCreatingLocation,
    super.quickCreateSettings,
    super.customerBranchId
  });

  factory OrderFormData.newFromOrderTypes(OrderTypes orderTypes) {
    return OrderFormData(
      orderTypes: orderTypes
    );
  }

  factory OrderFormData.createFromModel(Order order, OrderTypes orderTypes) {
    return BaseOrderFormData.createFromModel(order, orderTypes) as OrderFormData;
  }

  void fillFromBranch(Branch branch) {
    this.branch = branch.id;
    orderNameController!.text = branch.name!;
    orderAddressController!.text = branch.address!;
    orderPostalController!.text = branch.postal!;
    orderCityController!.text = branch.city!;
    orderCountryCode = branch.countryCode;
    orderContactController!.text = branch.contact!;
    orderEmailController!.text = branch.email!;
    orderTelController!.text = branch.tel!;
    orderMobileController!.text = branch.mobile!;
  }
}