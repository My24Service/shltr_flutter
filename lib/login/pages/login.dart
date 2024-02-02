import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shltr_flutter/login/widgets/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login.app_bar_title'.tr()),
        centerTitle: true,
      ),
      body: const LoginView(),
    );
  }
}
