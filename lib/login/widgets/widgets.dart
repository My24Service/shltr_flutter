import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/core/models/models.dart';
import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/company/models/models.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    _addListeners();

    return ModalProgressHUD(child: Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildTextFields(),
          Divider(),
          _buildButtons(),
        ],
      ),
    ), inAsyncCall: _saving);
  }

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _username = "";
  String _password = "";
  bool _saving = false;

  _addListeners() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _username = "";
    } else {
      _username = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                  labelText: 'login.username'.tr()
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  labelText: 'login.password'.tr()
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          createDefaultElevatedButton(
              'login.button_login'.tr(),
              _loginPressed
          ),
          SizedBox(height: 30),
          createElevatedButtonColored(
              'login.button_forgot_password'.tr(),
              _passwordReset
          ),
        ],
      ),
    );
  }

  _passwordReset () async {
    final url = await utils.getUrl('/frontend/#/reset-password');
    utils.launchURL(url.replaceAll('/api', ''));
  }

  _loginPressed () async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _saving = true;
    });

    SlidingToken? resultToken = await utils.attemptLogIn(_username, _password);

    if (resultToken == null) {
      setState(() {
        _saving = false;
      });

      displayDialog(
          context,
          'login.dialog_error_title'.tr(),
          'login.dialog_error_content'.tr()
      );
      return;
    }

    // fetch user info and determine type
    var userData = await utils.getUserInfo();
    var userInfo = userData['user'];
    // print(userInfo);

    setState(() {
      _saving = false;
    });


    // planning?
    if (userInfo is PlanningUser) {
      PlanningUser planningUser = userInfo;
      prefs.setInt('user_id', planningUser.id!);
      prefs.setString('email', planningUser.email!);
      prefs.setString('first_name', planningUser.firstName!);
      prefs.setString('submodel', 'planning_user');

      // navigate to orders
      // TODO go somewhere
    }

    // employee?
    if (userInfo is EmployeeUser) {
      EmployeeUser employeeUser = userInfo;
      prefs.setInt('user_id', employeeUser.id!);
      prefs.setString('email', employeeUser.email!);
      prefs.setString('first_name', employeeUser.firstName!);

      if (employeeUser.employee!.branch != null) {
        prefs.setString('submodel', 'branch_employee_user');
        prefs.setInt('employee_branch', employeeUser.employee!.branch!);
        // TODO go somewhere
      }
    }
  }
}
