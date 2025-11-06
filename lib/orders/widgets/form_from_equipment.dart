import 'package:my24_flutter_orders/widgets/form_from_equipment.dart';

import '../blocs/order_form_bloc.dart';
import '../models/form_data.dart';

class OrderFormFromEquipmentWidget extends BaseOrderFormFromEquipmentWidget<OrderFormBloc, OrderFormData> {
  OrderFormFromEquipmentWidget({
    super.key,
    required super.formData,
    required super.widgets,
    required super.orderlineFormData,
    required super.isPlanning,
    required super.orderPageMetaData,
  });
}

