import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:my24_flutter_member_models/public/models.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/tests/http_client.mocks.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

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
  tearDown(() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userInfoData');
    prefs.remove('companycode');
    prefs.remove('memberData');
  });

  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  testWidgets('loads login page', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();
    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;

    LoginPage page = LoginPage(
      bloc: bloc
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
    ).thenAnswer((_) async => http.Response("", 400));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsNothing);
    expect(find.byType(ShltrLogo), findsOneWidget);
    expect(find.byType(LoginButtons), findsOneWidget);
  });

  testWidgets('loads login page logged in', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();
    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;

    SharedPreferences.setMockInitialValues({
      'memberData': memberPublic
    });

    LoginPage page = LoginPage(
        bloc: bloc
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

    // member info public
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/member/detail-public-companycode/demo/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response(memberPublic, 200));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsOneWidget);
    expect(find.byType(ShltrLogo), findsNothing);
    expect(find.byType(LoginButtons), findsNothing);
  });

  testWidgets('loads login page with member from home', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();
    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;
    final Member demoMember = Member.fromJson(json.decode(memberPublic));

    LoginPage page = LoginPage(
      bloc: bloc,
      memberFromHome: demoMember,
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
    ).thenAnswer((_) async => http.Response("", 400));

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsOneWidget);
    expect(find.byType(ShltrLogo), findsNothing);
    expect(find.byType(LoginButtons), findsOneWidget);
  });

  testWidgets('does login successful', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();

    // return login request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // user info
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

    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;
    bloc.utils.memberByCompanycodeApi.httpClient = client;

    final HomeDoLoginState loginState = HomeDoLoginState(
        companycode: "demo",
        userName: "hoi",
        password: "test"
    );

    LoginPage page = LoginPage(bloc: bloc, initialMode: "login", loginState: loginState);

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsOneWidget);
    expect(find.byType(ShltrLogo), findsNothing);
    expect(find.byType(LoginButtons), findsNothing);

  });

  testWidgets('login user not found', (tester) async {
    final client = MockClient();
    final HomeBloc bloc = HomeBloc();

    // return login request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // return token request with a 200
    when(
        client.post(Uri.parse('https://demo.my24service-dev.com/api/jwt-token/refresh/'),
            headers: anyNamed('headers'),
            body: anyNamed('body')
        )
    ).thenAnswer((_) async => http.Response(tokenData, 200));

    // user info
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/company/user-info-me/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response("", 401));

    // member info public
    when(
        client.get(Uri.parse('https://demo.my24service-dev.com/api/member/detail-public-companycode/demo/'),
          headers: anyNamed('headers'),
        )
    ).thenAnswer((_) async => http.Response(memberPublic, 200));

    bloc.utils.httpClient = client;
    bloc.coreUtils.httpClient = client;
    bloc.utils.memberByCompanycodeApi.httpClient = client;

    final HomeDoLoginState loginState = HomeDoLoginState(
        companycode: "demo",
        userName: "hoi",
        password: "test"
    );

    LoginPage page = LoginPage(bloc: bloc, initialMode: "login", loginState: loginState);

    await mockNetworkImagesFor(() async => await tester.pumpWidget(
        createWidget(child: page))
    );
    await mockNetworkImagesFor(() async => await tester.pumpAndSettle());

    expect(find.byType(CompanyLogo), findsOneWidget);
    expect(find.byType(ShltrLogo), findsNothing);
    expect(find.byType(LoginButtons), findsOneWidget);
  });
}
