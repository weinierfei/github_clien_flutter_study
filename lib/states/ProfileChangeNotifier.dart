import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  bool get isLogin => user != null;

  // 如果用户信息发生变化 则更新信息 同时更新页面
  set user(User user) {
    if (user?.login != _profile.user?.login) {
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题 如果未设置 则默认蓝色
  ColorSwatch get theme => Global.themes
      .firstWhere((e) => e.value == _profile.theme, orElse: () => Colors.blue);

  // 主题改变后 通知其依赖项 让新主题生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color.value;
      notifyListeners();
    }
  }
}

class LocalModel extends ProfileChangeNotifier {
  // 获取用户的App语言配置 如果未null 则语言跟随系统
  Locale getLocal() {
    if (_profile.locale == null) {
      return null;
    }
    var t = _profile.locale.split("_");
    return Locale(t[0], t[1]);
  }

  String get locale => _profile.locale;

  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}
