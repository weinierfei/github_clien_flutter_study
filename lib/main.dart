import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/states/ProfileChangeNotifier.dart';
import 'package:provider/provider.dart';

import 'i10n/GmLocalizations.dart';
import 'routes/HomeRoute.dart';
import 'routes/LanguageRoute.dart';
import 'routes/LoginRoute.dart';
import 'routes/ThemeChangeRoute.dart';

void main() {
  Global.init().then((e) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider.value(value: ThemeModel()),
        ChangeNotifierProvider.value(value: UserModel()),
        ChangeNotifierProvider.value(value: LocalModel()),
      ],
      child: Consumer2<ThemeModel, LocalModel>(
        builder: (BuildContext context, themeModel, localeModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: themeModel.theme,
            ),
            onGenerateTitle: (context) {
              return GmLocalizations.of(context).title;
            },
            locale: localeModel.getLocal(),
            supportedLocales: [
              const Locale("en", "US"),
              const Locale("zh", "CN"),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GmLocalizationsDelegate(),
            ],
            localeResolutionCallback:
                (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocal() != null) {
                return localeModel.getLocal();
              } else {
                Locale locale;
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('en', 'US');
                }
                return locale;
              }
            },
            home: HomeRoute(),
            routes: <String, WidgetBuilder>{
              "login": (ctx) => LoginRoute(),
              "themes": (ctx) => ThemeChangeRoute(),
              "language": (ctx) => LanguageRoute(),
            },
          );
        },
      ),
    );
  }
}
