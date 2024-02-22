import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:my24_flutter_core/i18n.dart';
import 'package:my24_flutter_core/models/base_models.dart';
import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_core/widgets/widgets.dart';
import 'package:my24_flutter_member_models/public/api.dart';
import 'package:my24_flutter_member_models/public/models.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shltr_flutter/common/utils.dart';
import 'package:shltr_flutter/common/widgets.dart';
import 'package:shltr_flutter/home/blocs/home_bloc.dart';
import 'package:shltr_flutter/home/blocs/home_states.dart';

import '../../company/models/models.dart';
import '../../orders/order_bloc.dart';
import '../../orders/page.dart';

// we have three modes of entry:
// - not logged in, no member
// - not logged in, member
// - logged in
class LoginWidget extends StatefulWidget {
  final Member? member;
  final BaseUser? user;
  final My24i18n i18n;
  final memberApi = MemberListPublicBranchesApi();

  LoginWidget({
    super.key,
    required this.member,
    required this.user,
    required this.i18n
  });

  @override
  State<StatefulWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _companycodeController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CoreWidgets coreWidgets = CoreWidgets();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 600.0,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _buildBodyColumn(context),
        ),
    );
  }

  @override
  void dispose() {
    _companycodeController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildBodyColumn(BuildContext context) {
    if (widget.user == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildMemberSection(),
          LoginTextFields(
            usernameController: _usernameController,
            passwordController: _passwordController,
            i18n: widget.i18n
          ),
          const SizedBox(height: 10),
          LoginButtons(
            i18n: widget.i18n,
            usernameController: _usernameController,
            member: widget.member,
            passwordController: _passwordController,
            companycodeController: _companycodeController
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        _buildMemberSection(),
        const Divider(),
        LoggedInButtons(
          i18n: widget.i18n,
          isPlanning: widget.user is PlanningUser,
          user: widget.user,
          member: widget.member,
        )
      ],
    );
  }

  Widget _buildMemberSection() {
    // member logo and info when entering the app with member data
    if (widget.member != null) {
      return Column(
        children: [
          CompanyLogo(memberPicture: checkNull(widget.member!.companylogoUrl)),
          Center(child: buildMemberInfoCard(context, widget.member)),
        ]
      );
    }

    // return manual entry else
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ShltrLogo(),
          TypeAheadFormField<Member>(
            debounceDuration: const Duration(seconds: 1),
            minCharsForSuggestions: 2,
            textFieldConfiguration: TextFieldConfiguration(
              controller: _companycodeController,
              decoration: InputDecoration(
                  labelText: widget.i18n.$trans('typeahead_label_search_company')
              ),
            ),
            suggestionsCallback: (pattern) async {
              return await widget.memberApi.search(pattern);
            },
            itemBuilder: (context, Member suggestion) {
              return ListTile(
                title: Text(suggestion.companycode!),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (member) async {
              _companycodeController.text = member.companycode!;
            },
            validator: (value) {
              return null;
            },
            onSaved: (value) => {
            },
          ),
        ],
      )
    );
  }
}

class ShltrLogo extends StatelessWidget {
  const ShltrLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 210,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/icon/icon.png", cacheWidth: 100),
            ]
        )
    );
  }
}

class CompanyLogo extends StatelessWidget {
  final String memberPicture;
  const CompanyLogo({
    super.key,
    required this.memberPicture
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        height: 100,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(memberPicture, cacheWidth: 100),
            ]
        )
    );
  }
}

class LoginTextFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final My24i18n i18n;

  const LoginTextFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.i18n
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
              labelText: i18n.$trans('username')
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
              labelText: i18n.$trans('password')
          ),
          obscureText: true,
        )
      ],
    );
  }

}

class LoggedInButtons extends StatelessWidget {
  final My24i18n i18n;
  final bool isPlanning;
  final BaseUser? user;
  final Member? member;
  final CoreWidgets coreWidgets = CoreWidgets();

  LoggedInButtons({
    super.key,
    required this.i18n,
    required this.isPlanning,
    required this.member,
    required this.user,
  });

  _navOrders(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderListPage(
              bloc: OrderBloc(),
              fetchMode: OrderEventStatus.fetchAll,
            )
        )
    );
  }

  _navUnaccepted(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => OrderListPage(
              bloc: OrderBloc(),
              fetchMode: OrderEventStatus.fetchUnaccepted,
            )
        )
    );
  }

  _soon(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(const HomeEvent(status: HomeEventStatus.doAsync));
    bloc.add(HomeEvent(
      status: HomeEventStatus.soon,
      user: user,
      member: member
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        createDefaultElevatedButton(
            i18n.$trans('order_list'),
            () { _navOrders(context); }
        ),
        if (isPlanning)
          const SizedBox(height: 5),
        if (isPlanning)
          createDefaultElevatedButton(
              i18n.$trans('order_not_accepted_list'),
              () { _navUnaccepted(context); }
          ),
        coreWidgets.getMy24Divider(context),
        const SizedBox(height: 5),
        createDefaultElevatedButton(
            i18n.$trans('equipment_list'),
            () { _soon(context); }
        ),
        const SizedBox(height: 5),
        createDefaultElevatedButton(
            i18n.$trans('location_list'),
            () { _soon(context); }
        ),
        if (isPlanning)
          const SizedBox(height: 5),
        if (isPlanning)
          createDefaultElevatedButton(
              i18n.$trans('branch_list'),
              () { _soon(context); }
          ),
      ],
    );
  }
}

class LoginButtons extends StatelessWidget {
  final TextEditingController companycodeController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final My24i18n i18n;
  final Member? member;

  const LoginButtons({
    super.key,
    required this.i18n,
    required this.usernameController,
    required this.passwordController,
    required this.companycodeController,
    required this.member
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        createDefaultElevatedButton(
            i18n.$trans('button_login'),
            () async { _loginPressed(context); }
        ),
        const SizedBox(height: 30),
        createElevatedButtonColored(
            i18n.$trans('button_forgot_password'),
            _passwordReset
        ),
      ],
    );
  }

  _passwordReset () async {
    final url = await utils.getUrl('/frontend/#/reset-password');
    coreUtils.launchURL(url.replaceAll('/api', ''));
  }

  _loginPressed (BuildContext context) async {
    final bloc = BlocProvider.of<HomeBloc>(context);
    bloc.add(const HomeEvent(status: HomeEventStatus.doAsync));

    if (member == null) {
      if (companycodeController.text == "") {
        displayDialog(
            context,
            i18n.$trans('error_dialog_title_no_companycode'),
            i18n.$trans('error_dialog_content_no_companycode')
        );

        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('companycode', companycodeController.text);

      bloc.add(HomeEvent(
          status: HomeEventStatus.doLogin,
          doLoginState: HomeDoLoginState(
              companycode: companycodeController.text,
              userName: usernameController.text,
              password: passwordController.text
          )
      ));
    } else {
      bloc.add(HomeEvent(
          status: HomeEventStatus.doLogin,
          doLoginState: HomeDoLoginState(
              companycode: member!.companycode!,
              userName: usernameController.text,
              password: passwordController.text
          )
      ));
    }
  }
}