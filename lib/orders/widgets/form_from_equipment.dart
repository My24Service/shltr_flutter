import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'package:my24_flutter_core/i18n.dart';
import 'package:my24_flutter_core/models/base_models.dart';
import 'package:my24_flutter_core/widgets/slivers/app_bars.dart';
import 'package:my24_flutter_core/widgets/widgets.dart';

import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:my24_flutter_orders/models/orderline/form_data.dart';
import 'package:my24_flutter_orders/models/orderline/models.dart';
import 'package:my24_flutter_orders/blocs/order_form_bloc.dart';
import 'package:my24_flutter_orders/widgets/form/documents.dart';

import '../blocs/order_form_bloc.dart';
import '../models/form_data.dart';

final log = Logger('orders.widgets.form_from_equipment');

class OrderFormFromEquipmentWidget extends StatefulWidget {
  final OrderFormData formData;
  final CoreWidgets widgets;
  final My24i18n i18n;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final OrderPageMetaData orderPageMetaData;
  final OrderlineFormData orderlineFormData;

  OrderFormFromEquipmentWidget({
    super.key,
    required this.formData,
    required this.widgets,
    required this.i18n,
    required this.orderPageMetaData,
    required this.orderlineFormData
  });

  @override
  State<StatefulWidget> createState() => _OrderFormFromEquipmentState();
}

class _OrderFormFromEquipmentState extends State<OrderFormFromEquipmentWidget> {
  final TextEditingController remarksController = TextEditingController();
  bool setLocationToEquipment = false;

  @override
  void dispose() {
    super.dispose();
    remarksController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  String getAppBarTitle(BuildContext context) {
    return widget.i18n.$trans('app_bar_title_insert_from_equipment',
        namedArgs: {'orderType': widget.formData.orderType!});
  }

  SliverAppBar getAppBar(BuildContext context) {
    SmallAppBarFactory factory = SmallAppBarFactory(
        context: context, title: getAppBarTitle(context));
    return factory.createAppBar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
            slivers: <Widget>[
              getAppBar(context),
              SliverToBoxAdapter(child: getContent(context))
            ]
        )
    );
  }

  Widget getContent(BuildContext context) {
    remarksController.text = checkNull(widget.orderlineFormData.remarks);

    return Form(
        key: widget.formKey,
        child: Column(
          children: [
            widget.widgets.wrapGestureDetector(
                context,
                Text(My24i18n.tr('generic.info_remarks'))
            ),
            TextFormField(
                controller: remarksController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                validator: (value) {
                  return null;
                }),
            const SizedBox(height: 20),
            DocumentsWidget(
              formData: widget.formData,
              widgets: widget.widgets,
              orderId: null,
            ),
            const SizedBox(
              height: 10.0,
            ),
            widget.widgets.createSubmitButton(context, () => _addOrder(context)),
          ],
        )
    );
  }

  _addListeners() {
    remarksController.addListener(_remarksListen);
  }

  void _remarksListen() {
    if (remarksController.text.isEmpty) {
      widget.orderlineFormData.remarks = "";
    } else {
      widget.orderlineFormData.remarks = remarksController.text;
    }
  }

  _addOrder(BuildContext context) {
    if (widget.formKey.currentState!.validate() && widget.orderlineFormData.equipment != null &&
        widget.orderlineFormData.equipmentLocation != null) {
      widget.formKey.currentState!.save();

      Order newOrder = widget.formData.toModel();
      Orderline orderline = widget.orderlineFormData.toModel();

      final orderBloc = BlocProvider.of<OrderFormBloc>(context);
      orderBloc.add(const OrderFormEvent(status: OrderFormEventStatus.doAsync));
      orderBloc.add(OrderFormEvent(
          status: OrderFormEventStatus.insert,
          order: newOrder,
          orderLines: [orderline],
          infoLines: [],
          documents: widget.formData.documents,
      ));
    } else {
      log.severe("error creating order; equipment: ${widget.orderlineFormData.equipment}, equipment location: ${widget.orderlineFormData.equipmentLocation}");
      widget.widgets.displayDialog(context,
          My24i18n.tr('generic.error_dialog_title'),
          widget.i18n.$trans('error_adding')
      );
    }
  }
}
