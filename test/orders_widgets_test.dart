import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my24_flutter_orders/blocs/order_form_states.dart';
import 'package:my24_flutter_orders/widgets/empty.dart';
import 'package:my24_flutter_orders/widgets/list.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/tests/http_client.mocks.dart';
import 'package:my24_flutter_core/dev_logging.dart';

import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:my24_flutter_orders/widgets/detail.dart';
import 'package:my24_flutter_orders/widgets/error.dart';

import 'package:shltr_flutter/orders/pages/detail.dart';
import 'package:shltr_flutter/orders/pages/form.dart';
import 'package:shltr_flutter/orders/widgets/form.dart';
import 'package:shltr_flutter/orders/blocs/order_form_bloc.dart';
import 'package:shltr_flutter/orders/pages/list.dart';
import 'fixtures.dart';

Widget createWidget({Widget? child}) {
  return MaterialApp(
      home: Scaffold(
          body: Container(
              child: child
          )
      ),
  );
}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUpLogging();

  testWidgets('loads main list', (tester) async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    const String orders = '{"next": null, "previous": null, "count": 4, "num_pages": 1, "results": [$order]}';
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/?order_by=-start_date'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(orders, 200));

    OrderListPage widget = OrderListPage(bloc: orderBloc, fetchMode: OrderEventStatus.fetchAll);
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderListErrorWidget), findsNothing);
    expect(find.byType(OrderListEmptyWidget), findsNothing);
    expect(find.byType(OrderListWidget), findsOneWidget);
  });

  testWidgets('loads main list empty', (tester) async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return nothing with a 200
    const String orders = '{"next": null, "previous": null, "count": 0, "num_pages": 1, "results": []}';
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/?order_by=-start_date'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(orders, 200));

    OrderListPage widget = OrderListPage(bloc: orderBloc, fetchMode: OrderEventStatus.fetchAll);
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderListErrorWidget), findsNothing);
    expect(find.byType(OrderListEmptyWidget), findsOneWidget);
    expect(find.byType(OrderListWidget), findsNothing);
  });

  testWidgets('loads main list error', (tester) async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return a 500
    const String orders = '{"next": null, "previous": null, "count": 0, "num_pages": 1, "results": []}';
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/?order_by=-start_date'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(orders, 500));

    OrderListPage widget = OrderListPage(bloc: orderBloc, fetchMode: OrderEventStatus.fetchAll);
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderListErrorWidget), findsOneWidget);
    expect(find.byType(OrderListEmptyWidget), findsNothing);
    expect(find.byType(OrderListWidget), findsNothing);
  });

  testWidgets('loads detail', (tester) async {
    final client = MockClient();
    final orderBloc = OrderBloc();
    orderBloc.api.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(order, 200));

    OrderDetailPage widget = OrderDetailPage(
      orderId: 1,
      bloc: orderBloc,
    );
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderDetailWidget), findsOneWidget);
  });

  testWidgets('loads form edit', (tester) async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(order, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    OrderFormPage widget = OrderFormPage(
      pk: 1,
      bloc: orderFormBloc,
      fetchMode: OrderEventStatus.fetchAll
    );
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormWidget), findsOneWidget);
  });

  testWidgets('loads form new planning', (tester) async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    OrderFormPage widget = OrderFormPage(
        bloc: orderFormBloc,
        pk: null,
        fetchMode: OrderEventStatus.fetchAll
    );
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormWidget), findsOneWidget);
  });

  testWidgets('loads form new employee', (tester) async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;
    orderFormBloc.branchApi.httpClient = client;
    orderFormBloc.myBranchApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'branch_employee_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    // return my branch data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/company/branch-my/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(myBranchData, 200));

    OrderFormPage widget = OrderFormPage(
        bloc: orderFormBloc,
        pk: null,
        fetchMode: OrderEventStatus.fetchAll
    );
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormWidget), findsOneWidget);
  });

  testWidgets('loads form edit, enter data and submit', (tester) async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.orderlineApi.httpClient = client;
    orderFormBloc.infolineApi.httpClient = client;
    orderFormBloc.orderDocumentApi.httpClient = client;
    orderFormBloc.infolineApi.httpClient = client;
    orderFormBloc.locationApi.httpClient = client;
    orderFormBloc.equipmentApi.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': true,
      'submodel': 'planning_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return order data with a 200
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(order, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    // update order
    when(client.patch(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'), headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response(order, 200));

    // update orderline
    when(client.patch(Uri.parse('https://demo.my24service-dev.com/api/order/orderline/1/'), headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response(orderLine1, 200));

    // create orderline
    when(client.post(Uri.parse('https://demo.my24service-dev.com/api/order/orderline/'), headers: anyNamed('headers'), body: anyNamed('body')))
        .thenAnswer((_) async => http.Response(orderLine2, 201));

    OrderFormPage widget = OrderFormPage(
        pk: 1,
        bloc: orderFormBloc,
        fetchMode: OrderEventStatus.fetchAll
    );
    widget.utils.httpClient = client;

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormWidget), findsOneWidget);

    // enter some orderline data
    // var productFormField = find.byKey(const Key("product-form-field"));
    // await tester.enterText(productFormField, 'my product');
    //
    // var locationFormField = find.byKey(const Key("location-form-field"));
    // await tester.enterText(locationFormField, 'my location');
    //
    // var addOrderLineButton = find.byKey(const Key("add-orderline-button"));
    // await tester.ensureVisible(addOrderLineButton);
    // await tester.pumpAndSettle();
    // await tester.tap(addOrderLineButton);
    // await tester.pumpAndSettle();

    expectLater(orderFormBloc.stream, emitsInOrder([
      // isA<OrderLoadedState>(),
      // isA<OrderLineAddedState>(),
      isA<OrderFormLoadingState>(),
      isA<OrderUpdatedState>()
    ]));

    final button = find.byKey(const Key("order-submit")); //, skipOffstage: false);
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();

    await tester.tap(button);
    await tester.pumpAndSettle(const Duration(seconds: 60));

    verify(client.patch(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    verify(client.patch(Uri.parse('https://demo.my24service-dev.com/api/order/orderline/1/'), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
    // verify(client.post(Uri.parse('https://demo.my24service-dev.com/api/order/orderline/'), headers: anyNamed('headers'), body: anyNamed('body'))).called(1);
  });

  testWidgets('loads form edit employee', (tester) async {
    final client = MockClient();
    final orderFormBloc = OrderFormBloc();
    orderFormBloc.api.httpClient = client;
    orderFormBloc.privateMemberApi.httpClient = client;
    orderFormBloc.myBranchApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'member_has_branches': false,
      'submodel': 'branch_employee_user'
    });

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // branch data
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/company/branch-my/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(myBranchData, 200));

    // return order data with a 200
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/1/'),
            headers: anyNamed('headers')
        )
    ).thenAnswer((_) async => http.Response(order, 200));

    // return order types data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/order/order/order_types/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    OrderFormPage widget = OrderFormPage(
        pk: 1,
        bloc: orderFormBloc,
        fetchMode: OrderEventStatus.fetchAll
    );
    widget.utils.httpClient = client;
    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: widget))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormPage), findsOneWidget);
  });
}
