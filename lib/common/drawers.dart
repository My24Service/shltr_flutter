import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my24_flutter_core/i18n.dart';
import 'package:my24_flutter_core/utils.dart';
import 'package:my24_flutter_orders/blocs/order_bloc.dart';

import 'package:shltr_flutter/common/utils.dart';
import '../home/pages/home.dart';
import '../orders/pages/list.dart';

// Drawers
Widget createDrawerHeader() {
  return const SizedBox(height: 50);
}

// ListTile listTilePreferences(context) {
//   return ListTile(
//     title: Text(My24i18n.tr('utils.drawer_preferences')),
//     onTap: () {
//       // close the drawer and navigate
//       Navigator.pop(context);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => PreferencesPage(bloc: PreferencesBloc())));
//     }, // onTap
//   );
// }

ListTile listTileLogout(context) {
  return ListTile(
    title: Text(My24i18n.tr('utils.drawer_logout')),
    onTap: () async {
      // close the drawer and navigate
      Navigator.pop(context);

      bool loggedOut = await utils.logout();
      if (loggedOut == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const ShltrApp()));
      }
    }, // onTap
  );
}

ListTile listTileOrderList(BuildContext context, String text) {
  return ListTile(
    title: Text(text),
    onTap: () {
      // close the drawer and navigate
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderListPage(
                bloc: OrderBloc(),
                fetchMode: OrderEventStatus.fetchAll,
              )
          )
      );
    },
  );
}

ListTile listTileOrdersUnacceptedPage(BuildContext context, String text) {
  return ListTile(
    title: Text(text),
    onTap: () {
      // close the drawer and navigate
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderListPage(
                bloc: OrderBloc(),
                fetchMode: OrderEventStatus.fetchUnaccepted,
              )
          )
      );
    },
  );
}

ListTile listTileOrderPastList(BuildContext context, String text) {
  return ListTile(
    title: Text(text),
    onTap: () {
      // close the drawer and navigate
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OrderListPage(
              bloc: OrderBloc(),
              fetchMode: OrderEventStatus.fetchPast,
            )
          )
      );
    },
  );
}

Widget createPlanningDrawer(BuildContext context, SharedPreferences sharedPrefs) {
  // final int unreadCount = sharedPrefs.getInt('chat_unread_count');

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        createDrawerHeader(),
        listTileOrderList(
            context, My24i18n.tr('utils.drawer_planning_orders')),
        listTileOrdersUnacceptedPage(context, My24i18n.tr('utils.drawer_planning_orders_unaccepted')),
        listTileOrderPastList(context,
            My24i18n.tr('utils.drawer_planning_orders_past')),
        // listTileUserWorkHoursList(context, 'utils.drawer_planning_workhours'.tr()),
        const Divider(),
        // listTilePreferences(context),
        listTileLogout(context),
      ],
    ),
  );
}

Widget createEmployeeDrawer(BuildContext context, SharedPreferences sharedPrefs) {
  // final int unreadCount = sharedPrefs.getInt('chat_unread_count');

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        createDrawerHeader(),
        listTileOrderList(
            context, My24i18n.tr('utils.drawer_employee_orders')),
        listTileOrdersUnacceptedPage(context,
            My24i18n.tr('utils.drawer_employee_orders_unaccepted')),
        listTileOrderPastList(context,
            My24i18n.tr('utils.drawer_employee_orders_past')),
        const Divider(),
        // listTilePreferences(context),
        listTileLogout(context),
      ],
    ),
  );
}

Future<Widget?> getDrawerForUser(BuildContext context) async {
  String? submodel = await coreUtils.getUserSubmodel();
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  if (submodel == 'planning_user' && context.mounted) {
    return createPlanningDrawer(context, sharedPrefs);
  }

  if (submodel == 'branch_employee_user' && context.mounted) {
    return createEmployeeDrawer(context, sharedPrefs);
  }

  return null;
}

Future<Widget?> getDrawerForUserWithSubmodelLocal(BuildContext context, String? submodel) async {
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

  if (submodel == 'planning_user' && context.mounted) {
    return createPlanningDrawer(context, sharedPrefs);
  }

  if (submodel == 'branch_employee_user' && context.mounted) {
    return createEmployeeDrawer(context, sharedPrefs);
  }

  return null;
}
