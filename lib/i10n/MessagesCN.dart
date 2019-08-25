import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

final _keepAnalysisHappy = Intl.defaultLocale;

typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'zh_CN';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "auto": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "home": MessageLookupByLibrary.simpleMessage("Github客户端"),
        "language": MessageLookupByLibrary.simpleMessage("语言"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "logout": MessageLookupByLibrary.simpleMessage("注销"),
        "logoutTip": MessageLookupByLibrary.simpleMessage("确定要退出当前账号吗?"),
        "noDescription": MessageLookupByLibrary.simpleMessage("暂无描述!"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwordRequired": MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "theme": MessageLookupByLibrary.simpleMessage("换肤"),
        "title": MessageLookupByLibrary.simpleMessage("Github客户端"),
        "userName": MessageLookupByLibrary.simpleMessage("用户名"),
        "userNameOrPasswordWrong":
            MessageLookupByLibrary.simpleMessage("用户名或密码不正确"),
        "userNameRequired": MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "yes": MessageLookupByLibrary.simpleMessage("确定")
      };
}
