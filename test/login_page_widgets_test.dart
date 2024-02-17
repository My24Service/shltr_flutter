import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/tests/http_client.mocks.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';

import 'package:shltr_flutter/login/pages/login.dart';
import 'package:shltr_flutter/login/widgets/login.dart';

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

  testWidgets('loads login page', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();
    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;

    LoginPage page = LoginPage(bloc: bloc);

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
    ).thenAnswer((_) async => http.Response("", 400));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsNothing);
    expect(find.byType(ShltrLogo), findsOneWidget);

  });
}
