import 'package:flutter/material.dart';
import 'package:shltr_flutter/core/utils.dart';

Widget loadingNotice() {
  return Center(child: CircularProgressIndicator());
}

ElevatedButton createDefaultElevatedButton(String text, Function callback) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
    child: new Text(text),
    onPressed: callback as void Function()?,
  );
}

ElevatedButton createElevatedButtonColored(String text, Function callback,
    {foregroundColor = Colors.white, backgroundColor = Colors.blue}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    ),
    child: new Text(text),
    onPressed: callback as void Function()?,
  );
}

Widget buildMemberInfoCard(BuildContext context, member) => SizedBox(
  height: 200,
  width: 1000,
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ListTile(
          title: Text('${member.name}',
              style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(
              '${member.address}\n${member.countryCode}-${member.postal}\n${member.city}'),
          leading: Icon(
            Icons.home,
            color: Colors.blue[500],
          ),
        ),
        ListTile(
          title: Text('${member.tel}',
              style: TextStyle(fontWeight: FontWeight.w500)),
          leading: Icon(
            Icons.contact_phone,
            color: Colors.blue[500],
          ),
          onTap: () {
            if (member.tel != '' && member.tel != null) {
              utils.launchURL("tel://${member.tel}");
            }
          },
        ),
      ],
    ),
  ),
);

Future<dynamic> displayDialog(context, title, text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text(title), content: Text(text));
      });
}
