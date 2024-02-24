import 'package:flutter/material.dart';

import 'package:my24_flutter_core/utils.dart';

Widget loadingNotice() {
  return const Center(child: CircularProgressIndicator());
}

ElevatedButton createDefaultElevatedButton(String text, Function callback) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
    onPressed: callback as void Function()?,
    child: Text(text),
  );
}

ElevatedButton createElevatedButtonColored(String text, Function callback,
    {foregroundColor = Colors.white, backgroundColor = Colors.blue}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    ),
    onPressed: callback as void Function()?,
    child: Text(text),
  );
}

Widget buildMemberInfoCard(BuildContext context, member) => SizedBox(
  height: 160,
  width: 300,
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          title: Text('${member.name}',
              style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(
              '${member.address}\n${member.countryCode}-${member.postal}\n${member.city}'),
          leading: Icon(
            Icons.home,
            color: Colors.blue[500],
          ),
        ),
        ListTile(
          title: Text('${member.tel}',
              style: const TextStyle(fontWeight: FontWeight.w500)),
          leading: Icon(
            Icons.contact_phone,
            color: Colors.blue[500],
          ),
          onTap: () {
            if (member.tel != '' && member.tel != null) {
              coreUtils.launchURL("tel://${member.tel}");
            }
          },
        ),
      ],
    ),
  ),
);

Future<dynamic> displayDialog(BuildContext context, title, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(title), content: Text(text));
      });
}

createSnackBar(BuildContext context, String content) {
  final snackBar = SnackBar(
    content: Text(content),
    duration: const Duration(seconds: 1),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
