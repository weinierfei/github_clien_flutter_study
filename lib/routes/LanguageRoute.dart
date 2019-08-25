import 'package:flutter/material.dart';
import 'package:github_client_app/i10n/GmLocalizations.dart';
import 'package:github_client_app/states/ProfileChangeNotifier.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).primaryColor;
    var localeModel = Provider.of<LocalModel>(context);
    var gm = GmLocalizations.of(context);
    _buildLanguageItem(String s, String t) {
      return ListTile(
        title: Text(
          s,
          style: TextStyle(
            color: localeModel.locale == t ? color : null,
          ),
        ),
        trailing: localeModel.locale == t
            ? Icon(
                Icons.done,
                color: color,
              )
            : null,
        onTap: () {
          localeModel.locale = t;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          gm.language,
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildLanguageItem("简体中文", "zh_CN"),
          _buildLanguageItem("English", "en_US"),
          _buildLanguageItem(gm.auto, null),
        ],
      ),
    );
  }
}
