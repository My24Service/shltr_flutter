import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:my24_flutter_core/models/base_models.dart';
import 'package:my24_flutter_orders/models/infoline/form_data.dart';

import 'package:my24_flutter_orders/models/order/form_data.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/models/orderline/form_data.dart';

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
    final OrderlineFormData orderlineFormData = OrderlineFormData.createEmpty();
    final InfolineFormData infolineFormData = InfolineFormData.createEmpty();

    return OrderFormData(
      orderTypes: orderTypes,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      orderlineFormData: orderlineFormData,
      infolineFormData: infolineFormData
    );
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

  factory OrderFormData.createEmpty(OrderTypes orderTypes) {
    final OrderlineFormData orderlineFormData = OrderlineFormData.createEmpty();
    final InfolineFormData infolineFormData = InfolineFormData.createEmpty();

    return OrderFormData(
        orderTypes: orderTypes,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        orderlineFormData: orderlineFormData,
        infolineFormData: infolineFormData
    );
  }

  factory OrderFormData.createFromModel(Order order, OrderTypes orderTypes) {
    final TextEditingController typeAheadControllerCustomer = TextEditingController();
    final TextEditingController typeAheadControllerBranch = TextEditingController();

    final TextEditingController orderCustomerIdController = TextEditingController();
    orderCustomerIdController.text = checkNull(order.customerId);

    final TextEditingController orderNameController = TextEditingController();
    orderNameController.text = checkNull(order.orderName);

    final TextEditingController orderAddressController = TextEditingController();
    orderAddressController.text = checkNull(order.orderAddress);

    final TextEditingController orderPostalController = TextEditingController();
    orderPostalController.text = checkNull(order.orderPostal);

    final TextEditingController orderCityController = TextEditingController();
    orderCityController.text = checkNull(order.orderCity);

    final TextEditingController orderContactController = TextEditingController();
    orderContactController.text = checkNull(order.orderContact);

    final TextEditingController orderEmailController = TextEditingController();
    orderEmailController.text = checkNull(order.orderEmail);

    final TextEditingController orderTelController = TextEditingController();
    orderTelController.text = checkNull(order.orderTel);

    final TextEditingController orderMobileController = TextEditingController();
    orderMobileController.text = checkNull(order.orderMobile);

    final TextEditingController orderReferenceController = TextEditingController();
    orderReferenceController.text = checkNull(order.orderReference);

    final TextEditingController customerRemarksController = TextEditingController();
    customerRemarksController.text = checkNull(order.customerRemarks);

    final OrderlineFormData orderlineFormData = OrderlineFormData.createEmpty();
    final InfolineFormData infolineFormData = InfolineFormData.createEmpty();

    DateTime? startTime;
    if (order.startTime != null) {
      startTime = DateFormat('d/M/yyyy H:m:s').parse(
          '${order.startDate} ${order.startTime}');
    }

    DateTime? endTime;
    if (order.endTime != null) {
      endTime = DateFormat('d/M/yyyy H:m:s').parse(
          '${order.endDate} ${order.endTime}');
    }

    return OrderFormData(
      id: order.id,
      customerId: order.customerId,
      branch: order.branch,
      typeAheadControllerCustomer: typeAheadControllerCustomer,
      typeAheadControllerBranch: typeAheadControllerBranch,
      orderCustomerIdController: orderCustomerIdController,
      orderNameController: orderNameController,
      orderAddressController: orderAddressController,
      orderPostalController: orderPostalController,
      orderCityController: orderCityController,
      orderCountryCode: order.orderCountryCode,
      orderContactController: orderContactController,
      orderEmailController: orderEmailController,
      orderTelController: orderTelController,
      orderMobileController: orderMobileController,
      orderReferenceController: orderReferenceController,
      customerRemarksController: customerRemarksController,
      orderType: order.orderType,
      orderTypes: orderTypes,
      // // "start_date": "26/10/2020"
      startDate: DateFormat('d/M/yyyy').parse(order.startDate!),
      startTime: startTime,
      // // "end_date": "26/10/2020",
      endDate: DateFormat('d/M/yyyy').parse(order.endDate!),
      endTime: endTime,
      customerOrderAccepted: order.customerOrderAccepted,

      orderlineFormData: orderlineFormData,
      infolineFormData: infolineFormData,

      orderLines: order.orderLines,
      infoLines: order.infoLines,
      deletedOrderLines: [],
      deletedInfoLines: [],

      locations: [],
      isCreatingEquipment: false,
      isCreatingLocation: false,
      quickCreateSettings: null,
    );
  }
}