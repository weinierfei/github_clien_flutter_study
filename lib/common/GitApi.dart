import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/models/index.dart';

class GitApi {
  BuildContext context;
  Options _options;

  GitApi([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static Dio dio = Dio(BaseOptions(
    baseUrl: 'https://api.github.com/',
    headers: {
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    },
  ));

  static void init() {
    // 添加缓存拦截
    dio.interceptors.add(Global.netCache);
    // 设置用户token
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
    // 调试模式下使用代理抓包  同时禁用https
//    if (!Global.isRelease) {
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//          (client) {
//        client.findProxy = (uri) {
//          return "PROXY 10.1.10.250:8888";
//        };
//        client.badCertificateCallback =
//            (X509Certificate cate, String host, int port) => true;
//      };
//    }
  }

  // 登录 成功后返回用户信息
  Future<User> login(String login, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    var r = await dio.get(
      "/users/$login",
      options: _options.merge(
        headers: {HttpHeaders.authorizationHeader: basic},
        extra: {
          'noCache': true,
        }, // 登录接口不缓存
      ),
    );
    // 登录成功后更新公共头 后面所有的请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    // 清空所有缓存
    Global.netCache.cache.clear();
    // 更新token
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  // 获取用户项目列表
  Future<List<Repo>> getRepos(
      {Map<String, dynamic> queryParameters, refresh = false}) async {
    if (refresh) {
      // 如果是刷新 则删除缓存
      _options.extra.addAll({"refresh": true, "list": true});
    }

    var r = await dio.get<List>(
      'user/repos',
      queryParameters: queryParameters,
      options: _options,
    );

    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}
