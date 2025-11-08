import 'package:my24_flutter_core/tests/http_client.mocks.dart';
import 'package:shltr_flutter/orders/blocs/order_form_bloc.dart';

OrderFormBloc getOrderFormBloc(MockClient client) {
  final orderFormBloc = OrderFormBloc();
  orderFormBloc.api.httpClient = client;
  orderFormBloc.equipmentApi.httpClient = client;
  orderFormBloc.locationApi.httpClient = client;
  orderFormBloc.privateMemberApi.httpClient = client;
  orderFormBloc.utils.httpClient = client;
  orderFormBloc.coreUtils.httpClient = client;
  orderFormBloc.branchApi.httpClient = client;
  orderFormBloc.myBranchApi.httpClient = client;
  orderFormBloc.orderlineApi.httpClient = client;
  orderFormBloc.orderDocumentApi.httpClient = client;

  return orderFormBloc;
}