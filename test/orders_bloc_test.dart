import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my24_flutter_orders/blocs/order_form_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_form_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/tests/http_client.mocks.dart';
import 'package:my24_flutter_core/dev_logging.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/blocs/order_states.dart';
import 'package:my24_flutter_orders/models/order/models.dart';
import 'package:shltr_flutter/orders/models/form_data.dart';
import 'package:shltr_flutter/orders/blocs/order_form_bloc.dart';
import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUpLogging();

  test('Test fetch order detail', () async {
    final client = MockClient();
    final OrderFormBloc orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.locationApi.httpClient = client;
    orderFormBloc.equipmentApi.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(order, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    orderFormBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<OrderLoadedState>());
        expect(event.props[0], isA<OrderFormData>());
      })
    );

    expectLater(orderFormBloc.stream, emits(isA<OrderLoadedState>()));

    orderFormBloc.add(
        const OrderFormEvent(
            status: OrderFormEventStatus.fetchDetail,
            pk: 1
        ));
  });

  test('Test fetch all orders', () async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    const String orderData = '{"next": null, "previous": null, "count": 4, "num_pages": 1, "results": [$order]}';
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(orderData, 200));

    orderBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<OrdersLoadedState>());
        expect(event.props[0], isA<Orders>());
      })
    );

    expectLater(orderBloc.stream, emits(isA<OrdersLoadedState>()));

    orderBloc.add(
        const OrderEvent(status: OrderEventStatus.fetchAll));
  });

  test('Test order edit', () async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;

    Order orderModel = Order(
      id: 1,
      customerId: '123465',
      orderId: '987654',
      serviceNumber: '132789654',
      orderLines: [],
      infoLines: [],
      documents: []
    );

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(client.patch(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(order, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    orderFormBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<OrderUpdatedState>());
        expect(event.props[0], isA<Order>());
      })
    );

    expectLater(orderFormBloc.stream, emits(isA<OrderUpdatedState>()));

    orderFormBloc.add(
        OrderFormEvent(
          status: OrderFormEventStatus.update,
          order: orderModel,
          pk: 1,
          infoLines: [],
          orderLines: [],
          documents: [],
          deletedInfoLines: [],
          deletedOrderLines: [],
          deletedDocuments: []
        ));
  });

  test('Test order delete', () async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 204
    when(client.delete(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('', 204));

    orderBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<OrderDeletedState>());
        expect(event.props[0], true);
      })
    );

    expectLater(orderBloc.stream, emits(isA<OrderDeletedState>()));

    orderBloc.add(
        const OrderEvent(status: OrderEventStatus.delete, pk: 1));
  });

  test('Test order insert', () async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    Order orderModel = Order(
      customerId: '123465',
      orderId: '987654',
      serviceNumber: '132789654',
      orderLines: [],
      infoLines: []
    );

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/order/order/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(order, 201));

    Order newOrder = await orderBloc.api.insert(orderModel);
    expect(newOrder, isA<Order>());
  });

  test('Test fetch processing', () async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    // return token request with a 200
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    const String orderData = '{"next": null, "previous": null, "count": 4, "num_pages": 1, "results": [$order]}';
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/all_for_customer_not_accepted/'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(orderData, 200));

    orderBloc.stream.listen(
      expectAsync1((event) {
        expect(event, isA<OrdersUnacceptedLoadedState>());
        expect(event.props[0], isA<Orders>());
      })
    );

    expectLater(orderBloc.stream, emits(isA<OrdersUnacceptedLoadedState>()));

    orderBloc.add(
        const OrderEvent(status: OrderEventStatus.fetchUnaccepted));
  });

}
