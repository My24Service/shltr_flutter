import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/dev_logging.dart';
import 'package:my24_flutter_core/tests/http_client.mocks.dart';

import 'package:shltr_flutter/common/utils.dart';
import 'package:shltr_flutter/orders/pages/form_from_equipment.dart';
import 'package:shltr_flutter/orders/widgets/form_from_equipment.dart';
import 'fixtures.dart';
import 'helpers.dart';

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
  setUp(() async {
  });

  tearDown(() async {
    await utils.logout();
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUpLogging();

  testWidgets('loads minimal create order from equipment form', (tester) async {
    final client = MockClient();
    final orderFormBloc = getOrderFormBloc(client);

    OrderFormFromEquipmentPage page = OrderFormFromEquipmentPage(
      bloc: orderFormBloc,
      equipmentUuid: "c56ddfe1-f51b-4045-9d85-776e8ab0dcd4",
      equipmentOrderType: "storing",
    );

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/company/user-info-me/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response(planningUser, 200));

    // return member settings data with a 200
    when(client.get(Uri.parse('https://demo.my24service-dev.com/api/member/member/get_my_settings/'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(memberSettings, 200));

    // return equipment data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/equipment/equipment/c56ddfe1-f51b-4045-9d85-776e8ab0dcd4/uuid/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(equipment, 200));

    // return order types data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/order/order/order_types/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    // return branch data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/company/branch/1/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(myBranchData, 200));

    // return locations data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/equipment/location/list_for_select/?branch=4'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(locations, 200));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(OrderFormFromEquipmentPage), findsOneWidget);
    expect(find.byType(OrderFormFromEquipmentWidget), findsOneWidget);
  });
}
