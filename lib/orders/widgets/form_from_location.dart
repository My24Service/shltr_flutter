import 'package:my24_flutter_orders/widgets/form_from_location.dart';

import '../blocs/order_form_bloc.dart';
import '../models/form_data.dart';

class OrderFormFromLocationWidget extends BaseOrderFormFromLocationWidget<OrderFormBloc, OrderFormData> {
  OrderFormFromLocationWidget({
    super.key,
    required super.formData,
    required super.widgets,
    required super.orderlineFormData,
    required super.isPlanning,
    required super.orderPageMetaData,
  });
}

