import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_client_app/common/Global.dart';

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObject>();

  @override
  onRequest(RequestOptions options) {
    if (!Global.profile.cache.enable) {
      return options;
    }

    // 标记是否为下拉刷新
    bool refresh = options.extra['refresh'] == true;
    // 如果是下拉刷新 先删除缓存
    if (refresh) {
      if (options.extra['list'] == true) {
        cache.removeWhere((key, v) => key.contains(options.path));
      } else {
        delete(options.uri.toString());
      }

      return options;
    }

    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == 'get') {
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      var ob = cache[key];
      if (ob != null) {
        // 缓存是否过期
        if ((DateTime.now().millisecondsSinceEpoch - ob.timeStamp) / 1000 <
            Global.profile.cache.maxAge) {
          return cache[key].response;
        } else {
          cache.remove(key);
        }
      }
    }
  }

  @override
  onError(DioError err) {}

  @override
  onResponse(Response response) {
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
  }

  /// 写入缓存
  void _saveCache(Response response) {
    RequestOptions options = response.request;
    if (options.extra['noCache'] != true &&
        options.method.toLowerCase() == 'get') {
      // 缓存超过最大限制 则删除最早存入的
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra['cacheKey'] ?? options.uri.toString();
      cache[key] = CacheObject(response);
    }
  }

  void delete(String key) {
    cache.remove(key);
  }
}

class CacheObject {
  Response response;
  int timeStamp;

  CacheObject(this.response)
      : timeStamp = DateTime.now().millisecondsSinceEpoch;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}
