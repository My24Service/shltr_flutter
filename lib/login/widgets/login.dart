import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:shltr_flutter/core/utils.dart';
import 'package:shltr_flutter/core/widgets.dart';
import 'package:shltr_flutter/member/models/public/models.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

// we have three modes of entry:
// - not logged in, no member
// - not logged in, member
// - logged in
class LoginWidget extends StatefulWidget {
  final Member? member;
  final dynamic user;

  const LoginWidget({
    super.key,
    required this.member,
    required this.user
  });

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    _addListeners();

    return Container(
        padding: const EdgeInsets.all(16.0),
        child: _buildBodyColumn(),
      );
  }
  final TextEditingController _companycodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _username = "";
  String _password = "";

  @override
  void dispose() {
    _companycodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  _addListeners() {
    _emailController.addListener(_emailListen);
    _passwordController.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailController.text.isEmpty) {
      _username = "";
    } else {
      _username = _emailController.text;
    }
  }

  void _passwordListen() {
    if (_passwordController.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordController.text;
    }
  }
  
  Widget _buildBodyColumn() {
    if (!widget.user) {
      Column(
        children: <Widget>[
          _buildMemberSection(),
          const Divider(),
          _buildLoginTextFields(),
          const Divider(),
          _buildLoginButtons(),
        ],
      );
    }

    return Column(
      children: <Widget>[
        _buildMemberSection(),
        const Divider(),
        _buildLoggedInButtons()
      ],
    );
  }

  Widget _buildLogo(String companylogoUrl) => SizedBox(
      width: 100,
      height: 210,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
              Image.network(companylogoUrl, cacheWidth: 100),
          ]
      )
  );

  Widget _buildMemberSection() {
    // member logo and info when entering the app with member data
    if (widget.member != null) {
      return Center(
          child: Column(
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(widget.member!.companylogoUrl!),
                      Flexible(
                          child: buildMemberInfoCard(context, widget.member)
                      )
                    ]
                ),
              ]
          )
      );
    }

    // return manual entry else
    return Center(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _companycodeController,
            decoration: InputDecoration(
                labelText: 'login.companycode'.tr()
            ),
          )
        ]
      )
    );
  }

  Widget _buildLoginTextFields() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
              labelText: 'login.username'.tr()
          ),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              labelText: 'login.password'.tr()
          ),
          obscureText: true,
        )
      ],
    );
  }

  Widget _buildLoginButtons() {
    return Column(
      children: <Widget>[
        createDefaultElevatedButton(
            'login.button_login'.tr(),
            _loginPressed
        ),
        const SizedBox(height: 30),
        createElevatedButtonColored(
            'login.button_forgot_password'.tr(),
            _passwordReset
        ),
      ],
    );
  }

  Widget _buildLoggedInButtons() {
    return Column(
      children: <Widget>[
        createDefaultElevatedButton(
            'orders.list'.tr(),
            _navOrders
        ),
      ],
    );
  }

  _navOrders() {
    // TODO
  }

  _passwordReset () async {
    final url = await utils.getUrl('/frontend/#/reset-password');
    utils.launchURL(url.replaceAll('/api', ''));
  }

  _loginPressed () async {
    final bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(const HomeEvent(status: HomeEventStatus.doAsync));

    if (widget.member == null) {
      if (_companycodeController.text == "") {
        // TODO show error
        return;
      }

      bloc.add(HomeEvent(
          status: HomeEventStatus.doLogin,
          doLoginState: HomeDoLoginState(
              companycode: _companycodeController.text,
              userName: _username,
              password: _password
          )
      ));
    }
  }
}
