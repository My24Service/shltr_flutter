import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my24_flutter_equipment/blocs/location_bloc.dart';
import 'package:my24_flutter_member_models/public/models.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/dev_logging.dart';
import 'package:my24_flutter_core/tests/http_client.mocks.dart';

import 'package:shltr_flutter/common/utils.dart';
import 'package:shltr_flutter/equipment/pages/location_detail.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/pages/login.dart';
import 'package:shltr_flutter/home/widgets/login.dart';
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
  setUp(() async {
  });

  tearDown(() async {
    await utils.logout();
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  setUpLogging();

  testWidgets('loads location detail with location uuid from login page', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();
    final Member demoMember = Member.fromJson(json.decode(memberPublic));
    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;
    bloc.utils.memberByCompanycodeApi.httpClient = client;

    final EquipmentLocationBloc equipmentLocationBloc = EquipmentLocationBloc();
    equipmentLocationBloc.orderApi.httpClient = client;
    equipmentLocationBloc.locationApi.httpClient = client;
    equipmentLocationBloc.equipmentApi.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'companycode': 'demo',
      'memberData': memberPublic,

    });

    LoginPage page = LoginPage(
      bloc: bloc,
      languageCode: 'nl',
      locationUuid: "c56ddfe1-f51b-4045-9d85-776e8ab0dcd4",
      equipmentLocationBloc: equipmentLocationBloc,
      memberFromHome: demoMember,
      isLoggedIn: true,
    );
    page.coreUtils.httpClient = client;
    page.utils.httpClient = client;
    page.utils.memberByCompanycodeApi.httpClient = client;
    page.utils.memberApi.httpClient = client;

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

    // member info public
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/member/detail-public-companycode/demo/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response(memberPublic, 200));

    // initial data
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/get-initial-data/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response(initialData, 200));

    // return orders data with a 200
    when(client.get(
        Uri.parse('https://demo.my24service-dev.com/api/order/order/all_for_equipment_location/?location=1'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(ordersEmpty, 200));

    // return location data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/equipment/location/c56ddfe1-f51b-4045-9d85-776e8ab0dcd4/uuid/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(location, 200));

    // return locations data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/equipment/equipment/?location=1'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(equipmentPaginated, 200));

    // return order types data with a 200
    when(client.get(Uri.parse(
        'https://demo.my24service-dev.com/api/order/order/order_types/'),
        headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(orderTypes, 200));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(LocationDetailPage), findsOneWidget);
    expect(find.byType(CompanyLogo), findsNothing);
    expect(find.byType(ShltrLogo), findsNothing);
    expect(find.byType(LoginButtons), findsNothing);
  });
}
